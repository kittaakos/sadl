/*
 * generated by Xtext
 */
package com.ge.research.sadl.ui;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.ui.plugin.AbstractUIPlugin;

import java.io.PrintStream;

import org.eclipse.ui.console.IOConsoleOutputStream;
import org.eclipse.xtext.ui.editor.DirtyStateEditorSupport;
import org.eclipse.xtext.ui.editor.IXtextEditorCallback;
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider;
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper;
import org.eclipse.xtext.ui.editor.preferences.LanguageRootPreferencePage;
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor;
import org.eclipse.xtext.ui.editor.quickfix.XtextQuickAssistProcessor;
import org.eclipse.xtext.ui.editor.reconciler.XtextReconciler;
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.syntaxcoloring.ISemanticHighlightingCalculator;
import org.eclipse.xtext.ui.editor.templates.XtextTemplateContextType;

import com.ge.research.sadl.builder.MessageManager.MessageType;
import com.ge.research.sadl.ui.contentassist.SadlTemplateContextType;
import com.ge.research.sadl.ui.editor.SadlDirtyStateEditorSupport;
import com.ge.research.sadl.ui.editor.SadlHyperlinkHelper;
import com.ge.research.sadl.ui.properties.SadlRootPreferencePage;
import com.ge.research.sadl.ui.quickfix.TemplateIssueResolutionAcceptor;
import com.ge.research.sadl.ui.quickfix.TemplateQuickAssistProcessor;
import com.ge.research.sadl.ui.syntaxcoloring.SadlHighlightingConfiguration;
import com.ge.research.sadl.ui.syntaxcoloring.SadlSemanticHighlightingCalculator;
import com.ge.research.sadl.ui.syntaxcoloring.SadlTokenToAttributeIdMapper;
import com.google.inject.name.Names;

/**
 * Use this class to register components to be used within the IDE.
 */
public class SadlUiModule extends com.ge.research.sadl.ui.AbstractSadlUiModule {

    // Constructs our Guice configurator.
    public SadlUiModule(AbstractUIPlugin plugin) {
        super(plugin);
		IOConsoleOutputStream iocos = SadlConsole.getOutputStream(MessageType.INFO);
		System.setOut(new PrintStream(iocos));
		System.setErr(new PrintStream(SadlConsole.getOutputStream(MessageType.ERROR)));
		 
//		this is to prevent XtextReconcilerDebuger from continually reporting errors when debug level isn't initialized
		Logger log = Logger.getLogger(XtextReconciler.class);
		log.setLevel(Level.WARN);
    }

    // Registers our own custom Dirty State Handler to ensure the editor's
    // contents is reloaded properly if other files change.
    public Class<? extends DirtyStateEditorSupport> bindDirtyStateEditorSupport() {
    	return SadlDirtyStateEditorSupport.class;
    }

    // Customizes our hyperlink helper.
    public Class<? extends IHyperlinkHelper> bindIHyperlinkHelper() {
        return SadlHyperlinkHelper.class;
    }

    // Customizes our language's root preference page.
      public Class<? extends LanguageRootPreferencePage> bindLanguageRootPreferencePage() {
        return SadlRootPreferencePage.class;
    }

    // Registers our own syntax coloring styles.
    public Class<? extends IHighlightingConfiguration> bindILexicalHighlightingConfiguration() {
        return SadlHighlightingConfiguration.class;
    }

    // Maps our token names to our syntax coloring styles.
    public Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindTokenToAttributeIdMapper() {
        return SadlTokenToAttributeIdMapper.class;
    }

    // Maps our Ecore nodes to our syntax coloring styles.
    public Class<? extends ISemanticHighlightingCalculator> bindISemanticHighlightingCalculator() {
        return SadlSemanticHighlightingCalculator.class;
    }

    // Registers our own custom template variable resolver.
    public Class<? extends XtextTemplateContextType> bindTemplateContextType() {
        return SadlTemplateContextType.class;
    }

    // Registers our own custom quick assist processor to support templates.
    public Class<? extends XtextQuickAssistProcessor> bindXtextQuickAssistProcessor() {
        return TemplateQuickAssistProcessor.class;
    }

    // Registers our own custom issue resolution acceptor to support templates.
    public Class<? extends IssueResolutionAcceptor> bindIssueResolutionAcceptor() {
        return TemplateIssueResolutionAcceptor.class;
    }
    
    public void configureXtextEditorErrorTickUpdater(com.google.inject.Binder binder) {
    	binder.bind(IXtextEditorCallback.class).annotatedWith(Names.named("editor.tracker")).to(SadlSemanticHighlightingCalculator.class);
    }
}
