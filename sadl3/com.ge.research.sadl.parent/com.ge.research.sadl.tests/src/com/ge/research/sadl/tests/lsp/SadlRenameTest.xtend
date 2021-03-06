package com.ge.research.sadl.tests.lsp

import com.google.common.base.Throwables
import org.eclipse.emf.common.util.URI
import org.eclipse.lsp4j.Position
import org.eclipse.lsp4j.RenameParams
import org.eclipse.lsp4j.TextDocumentIdentifier
import org.eclipse.lsp4j.WorkspaceEdit
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.testing.TextDocumentPositionConfiguration
import org.junit.Test

import static org.junit.Assert.assertTrue
import static org.junit.Assert.fail

import static extension com.ge.research.sadl.tests.helpers.XtendTemplateHelper.unifyEOL

class SadlRenameTest extends AbstractSadlLanguageServerTest {

	@Test
	def void testRenameDecl_MustEscapeID() {
		testRename[
			model = '''
				uri "http://sadl.org/test.sadl".
				Foo is a class.
			'''
			line = 1
			newName = 'uri'
			workspaceEdit = '''
				changes :
					TestMe.sadl : ^uri [[1, 0] .. [1, 3]]
				documentChanges : 
			'''
		]
	}

	@Test
	def void testRenameDecl_NoOtherRefs() {
		testRename[
			model = '''
				uri "http://sadl.org/test.sadl".
				Foo is a class.
			'''
			line = 1
			newName = 'Bar'
			workspaceEdit = '''
				changes :
					TestMe.sadl : Bar [[1, 0] .. [1, 3]]
				documentChanges : 
			'''
		]
	}

	@Test
	def void testRenameDecl_OneRefInSameFile() {
		testRename[
			model = '''
				uri "http://sadl.org/test.sadl".
				Foo is a class.
				myFoo is a Foo.
			'''
			line = 1
			newName = 'Bar'
			workspaceEdit = '''
				changes :
					TestMe.sadl : Bar [[1, 0] .. [1, 3]]
					Bar [[2, 11] .. [2, 14]]
				documentChanges : 
			'''
		]
	}

	@Test
	def void testRenameRef_OneRefInSameFile() {
		testRename[
			model = '''
				uri "http://sadl.org/test.sadl".
				Foo is a class.
				myFoo is a Foo.
			'''
			line = 2
			column = 14
			newName = 'Bar'
			workspaceEdit = '''
				changes :
					TestMe.sadl : Bar [[1, 0] .. [1, 3]]
					Bar [[2, 11] .. [2, 14]]
				documentChanges : 
			'''
		]
	}

	@Test
	def void testRenameDecl_MultiFile() {
		testRename[
			model = '''
				uri "http://sadl.org/test.sadl".
				Foo is a class.
			'''
			line = 1
			newName = 'Bar'
			workspaceEdit = '''
				changes :
					Other.sadl : Bar [[2, 11] .. [2, 14]]
					TestMe.sadl : Bar [[1, 0] .. [1, 3]]
				documentChanges : 
			'''
			filesInScope = #{'Other.sadl' -> '''
				uri "http://sadl.org/other.sadl".
				import "http://sadl.org/test.sadl".
				MyFoo is a Foo.
			'''}
		]
	}

	@Test
	def void testRenameConflict() {
		testRename[
			model = '''
				uri "http://sadl.org/test.sadl".
				Foo is a class.
			'''
			line = 1
			newName = 'MyFoo'
			error = 'Refactoring cannot be performed'
			filesInScope = #{'Other.sadl' -> '''
				uri "http://sadl.org/other.sadl".
				import "http://sadl.org/test.sadl".
				MyFoo is a Foo.
			'''}
		]
	}

	override assertEquals(String expected, String actual) {
		super.assertEquals(expected.unifyEOL, actual.unifyEOL)
	}

	// Overridden to be able to sort by resource name: https://github.com/crapo/sadlos2/issues/475
	override dispatch String toExpectation(WorkspaceEdit it) '''
		changes :
			«IF changes !== null»
				«FOR entry : changes.entrySet.toList.sortBy[URI.createURI(key).lastSegment]»
					«URI.createURI(entry.key).lastSegment» : «entry.value.toExpectation»
				«ENDFOR»
			«ENDIF»
		documentChanges : 
			«IF !documentChanges.nullOrEmpty»
				«FOR entry: documentChanges.filter[isLeft].map[getLeft]»
					«entry.toExpectation»
				«ENDFOR»
				«FOR entry: documentChanges.filter[isRight].map[getRight]»
					«entry.toExpectation»
				«ENDFOR»
			«ENDIF»
	'''

	protected def void testRename((TestRenameConfiguration)=>void configurator) {
		val extension configuration = new TestRenameConfiguration
		configuration.filePath = '''TestMe.«fileExtension»'''
		configurator.apply(configuration)
		val uri = initializeContext(configuration).uri
		if (!configuration.error.nullOrEmpty) {
			try {
				languageServer.rename(new RenameParams => [
					textDocument = new TextDocumentIdentifier(uri)
					position = new Position(line, column)
					it.newName = configuration.newName
				]).get
				fail('''Expceted a failure with message: '«configuration.error»'.''')
			} catch (Exception e) {
				val cause = Throwables.getRootCause(e);
				assertTrue(cause.message.contains(configuration.error))
			}
		} else {
			val edit = languageServer.rename(new RenameParams => [
				textDocument = new TextDocumentIdentifier(uri)
				position = new Position(line, column)
				it.newName = configuration.newName
			]).get
			assertEquals(workspaceEdit, edit.toExpectation)
		}
	}

	@Accessors
	static class TestRenameConfiguration extends TextDocumentPositionConfiguration {
		String newName
		String workspaceEdit
		String error
	}

}
