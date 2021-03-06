/************************************************************************
 * Copyright © 2007-2017 - General Electric Company, All Rights Reserved
 * 
 * Project: SADL
 * 
 * Description: The Semantic Application Design Language (SADL) is a
 * language for building semantic models and expressing rules that
 * capture additional domain knowledge. The SADL-IDE (integrated
 * development environment) is a set of Eclipse plug-ins that
 * support the editing and testing of semantic models using the
 * SADL language.
 * 
 * This software is distributed "AS-IS" without ANY WARRANTIES
 * and licensed under the Eclipse Public License - v 1.0
 * which is available at http://www.eclipse.org/org/documents/epl-v10.php
 * 
 ***********************************************************************/
package com.ge.research.sadl.ui.tests.contentassist

import com.ge.research.sadl.ide.editor.contentassist.IOntologyContextProvider
import com.ge.research.sadl.processing.IModelProcessorProvider
import com.ge.research.sadl.tests.AbstractLinkingTest
import com.ge.research.sadl.ui.OutputStreamStrategy
import com.ge.research.sadl.ui.tests.SADLUiInjectorProvider
import com.google.common.collect.ImmutableMap
import com.google.inject.Inject
import com.google.inject.Injector
import com.google.inject.Provider
import java.io.InputStream
import java.util.Arrays
import org.eclipse.core.runtime.Platform
import org.eclipse.emf.common.util.URI
import org.eclipse.jface.text.contentassist.ICompletionProposal
import org.eclipse.swt.widgets.Shell
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext.Builder
import org.eclipse.xtext.preferences.PreferenceKey
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.ui.XtextProjectHelper
import org.eclipse.xtext.ui.editor.XtextSourceViewerConfiguration
import org.eclipse.xtext.ui.editor.contentassist.XtextContentAssistProcessor
import org.eclipse.xtext.ui.editor.preferences.IPreferenceStoreAccess
import org.eclipse.xtext.ui.resource.IResourceSetProvider
import org.eclipse.xtext.ui.testing.ContentAssistProcessorTestBuilder
import org.eclipse.xtext.ui.testing.util.ResourceLoadHelper
import org.eclipse.xtext.util.CancelIndicator
import org.eclipse.xtext.util.TextRegion
import org.eclipse.xtext.validation.CheckMode
import org.eclipse.xtext.validation.IResourceValidator
import org.junit.After
import org.junit.AfterClass
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Rule
import org.junit.rules.TestName
import org.junit.runner.RunWith

import static org.eclipse.core.runtime.IPath.SEPARATOR
import static org.eclipse.xtext.ui.testing.util.IResourcesSetupUtil.*
import static org.junit.Assert.*

/**
 * Base content assist plug-in test for SADL.
 * 
 * @author akos.kitta 
 */
@RunWith(XtextRunner)
@InjectWith(SADLUiInjectorProvider)
abstract class AbstractSadlContentAssistTest extends AbstractLinkingTest implements ResourceLoadHelper {

	protected static val PROJECT_NAME = 'testProject'

	static val RESOURCES = ImmutableMap.builder
		.put('Bar.sadl', '''uri "http://barUri". Bar is a class.''')
		.put('NotVisible.sadl', '''uri "http://notVisibleUri". NotVisible is a class.''')
		.put('Shape.sadl', '''uri "http://shape". Shape is a class described by area with values of type float.''')
		.put('Circle.sadl', '''uri "http://circle". import "http://shape". Circle is a type of Shape described by radius with values of type float.''')
		.put('Rectangle.sadl', '''uri "http://rectangle". import "http://shape". Rectangle is a type of Shape, described by height with values of type float, described by width with values of type float.''')
		.build

	@Rule
	public val name = new TestName();
	
	@Inject
	Provider<Builder> builderProvider;

	@Inject
	Injector injector;

	@Inject
	IPreferenceStoreAccess access;

	val modifiedPreferences = <String>newHashSet();

	@BeforeClass
	static def void assertRunningPlatform() {
		assertTrue('''
		These tests require a running Eclipse platform.
		Execute them as a JUnit Plug-in Test.
		If you see this error from Maven, then please configure your POM to use Tycho Surefire correctly for test execution.''',
			Platform.isRunning);
	}

	@BeforeClass
	def static void initWorkspace() {
		// Make sure console is redirected for the tests.
		OutputStreamStrategy.STD.use;
		val project = createProject(PROJECT_NAME);
		addNature(project, XtextProjectHelper.NATURE_ID);
		addBuilder(project, XtextProjectHelper.BUILDER_ID);
		RESOURCES.forEach[fileName, content|createFile('''«PROJECT_NAME»«SEPARATOR»«fileName»''', content)];
		fullBuild;
		waitForBuild;
	}

	@AfterClass
	def static void cleanWorkspace() {
		projects.forEach[delete(true, monitor)];
		waitForBuild;
		assertTrue('''Expected empty workspace. Workspace content was: «Arrays.toString(projects)».''', projects.empty);
	}

	@Before
	def void before() {
		OutputStreamStrategy.STD.use;
	}

	@After
	def void after() {
		resetPreferences();
	}

	protected def void resetPreferences() {
		modifiedPreferences.forEach [
			access.getWritablePreferenceStore(project).setToDefault(it);
		];
	}

	protected def updatePreference(PreferenceKey it) {
		val store = access.getWritablePreferenceStore(project);
		store.setValue(id, defaultValue);
		modifiedPreferences.add(id);
	}

	override getResourceFor(InputStream stream) {
		val uri = URI.createURI('''platform:/resource/«PROJECT_NAME»/«name.methodName»«fileExtension»''');
		val resource = resourceSet.createResource(uri) as XtextResource;
		try {
			resource.load(stream, null);
			// XXX akitta: this is bad, but the same is happening in the editor.
			// Validation runs, validator recursively resolves and validates imported 
			// resources. During the validation, the ontology model is attached to all
			// other imported resources.
			val validator = resource.resourceServiceProvider.get(IResourceValidator);
			validator.validate(resource, CheckMode.ALL, CancelIndicator.NullImpl);
		} catch (Exception e) {
			Exceptions.sneakyThrow(e);
		}
		return resource;
	}

	protected static def ContentAssistProcessorTestBuilder.ProposalTester assertProposalIsNot(
		ContentAssistProcessorTestBuilder builder, String missing) {

		try {
			builder.assertProposal(missing)
			throw new RuntimeException('''The proposal '«missing»' expected to be not present. But it was.''');
		} catch (AssertionError e) {
			// Tricky, but this is the correct way since we have negated the assertion.	
			if (!e.message.startsWith('''No such proposal: «missing»''')) {
				throw e;
			}
		}
	}

	protected static def getProject() {
		val project = root.getProject(PROJECT_NAME);
		assertTrue('''Project '«project»' is not accessible.''', project.accessible);
		return project;
	}

	protected static def getProjects() {
		return root.projects;
	}

	protected def newBuilder(String content) {
		val builder = new SadlContentAssistProcessorTestBuilder(injector, this, builderProvider) {

			override protected toString(ICompletionProposal proposal) {
				return super.toString(proposal).trim;
			}

		};
		return builder.append(content) as SadlContentAssistProcessorTestBuilder;
	}

	protected def <T> get(Class<T> clazz) {
		return injector.getInstance(clazz);
	}
	
	protected def getFileExtension() {
		return '.sadl';
	}

	private def getResourceSet() {
		val resourceSetProvider = injector.getInstance(IResourceSetProvider);
		val resourceSet = resourceSetProvider.get(project);
		assertNotNull('''Resource set was null for project: «project».''', resourceSet);
		return resourceSet;
	}

	protected static class SadlContentAssistProcessorTestBuilder extends ContentAssistProcessorTestBuilder {

		protected val Provider<Builder> builderProvider;

		new(Injector injector, ResourceLoadHelper helper, Provider<Builder> builderProvider) throws Exception {
			super(injector, helper)
			this.builderProvider = builderProvider;
		}

		def getOntologyContext() {
			val document = getDocument(fullTextToBeParsed);
			val Shell shell = new Shell();
			try {
				val configuration = get(XtextSourceViewerConfiguration);
				val sourceViewer = getSourceViewer(shell, document, configuration);
				val contentAssist = configuration.getContentAssistant(sourceViewer);
				val contentType = document.getContentType(cursorPosition);
				val processor = contentAssist.getContentAssistProcessor(contentType);
				if (processor instanceof XtextContentAssistProcessor) {
					val contexts = document.readOnly([
						return processor.contextFactory.create(sourceViewer, document.length, it);
					]);
					val modelProcessor = document.readOnly([
						val provider = get(IModelProcessorProvider);
						return provider.getProcessor(it);
					]);
					for (context : contexts) {
						val ontologyContext = get(IOntologyContextProvider).getOntologyContext(context.toIdeContext, modelProcessor);
						if (ontologyContext.present) {
							return ontologyContext.get;
						}
					}
				}
				return null;
			} finally {
				shell.dispose;
			}
		}

		protected def ContentAssistContext toIdeContext(org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext c) {
			val builder = builderProvider.get()
			val replaceRegion = c.replaceRegion
			builder
				.setPrefix(c.prefix)
				.setSelectedText(c.selectedText)
				.setRootModel(c.rootModel)
				.setRootNode(c.rootNode)
				.setCurrentModel(c.currentModel)
				.setPreviousModel(c.previousModel)
				.setCurrentNode(c.currentNode)
				.setLastCompleteNode(c.lastCompleteNode)
				.setOffset(c.offset)
				.setReplaceRegion(new TextRegion(replaceRegion.offset, replaceRegion.length))
				.setResource(c.resource)
			for (grammarElement : c.firstSetGrammarElements) {
				builder.accept(grammarElement)
			}
			return builder.toContext()
		}

	}
	

}
