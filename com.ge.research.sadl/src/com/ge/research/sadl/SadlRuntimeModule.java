/************************************************************************
 * Copyright 2007-2014 - General Electric Company, All Rights Reserved
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
/*
 * generated by Xtext
 */
package com.ge.research.sadl;

import org.eclipse.xtext.linking.ILinkingService;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.IDefaultResourceDescriptionStrategy;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.scoping.IGlobalScopeProvider;
import org.eclipse.xtext.scoping.impl.ImportUriResolver;
import org.eclipse.xtext.service.SingletonBinding;

import com.ge.research.sadl.builder.SadlConfigurationManagerProvider;
import com.ge.research.sadl.builder.SadlModelManager;
import com.ge.research.sadl.conversion.SadlTerminalConverters;
import com.ge.research.sadl.resource.SadlResourceDescriptionStrategy;
import com.ge.research.sadl.scoping.SadlGlobalScopeProvider;
import com.ge.research.sadl.scoping.SadlImportUriResolver;
import com.ge.research.sadl.scoping.SadlLinkingService;
import com.ge.research.sadl.resource.SadlResource;
import com.ge.research.sadl.naming.SadlSimpleNameProvider;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class SadlRuntimeModule extends com.ge.research.sadl.AbstractSadlRuntimeModule {
    // Registers our SADL model manager.
    @SingletonBinding
    public Class<? extends SadlModelManager> bindSadlModelManager() {
        return SadlModelManager.class;
    }
    @SingletonBinding
    public Class<? extends SadlConfigurationManagerProvider> bindSadlConfigurationManagerProvider() {
    	return SadlConfigurationManagerProvider.class;
    }

    // Registers our own URI resolver to handle file:// and http://.
    public Class<? extends ImportUriResolver> bindImportUriResolver() {
        return SadlImportUriResolver.class;
    }

    @Override
    public Class<? extends IGlobalScopeProvider> bindIGlobalScopeProvider() {
        return SadlGlobalScopeProvider.class;
    }

    @Override
    public Class<? extends ILinkingService> bindILinkingService() {
        return SadlLinkingService.class;
    }

	public Class<? extends org.eclipse.xtext.conversion.IValueConverterService> bindIValueConverterService() {
		return SadlTerminalConverters.class;
	}

	@Override
	public Class<? extends XtextResource> bindXtextResource() {
		return SadlResource.class;
	}

	public Class<? extends IDefaultResourceDescriptionStrategy> bindIDefaultResourceDescriptionStrategy() {
		return SadlResourceDescriptionStrategy.class;
	}

	public Class<? extends IQualifiedNameProvider> bindIQualifiedNameProvider() {
		return SadlSimpleNameProvider.class;
	}


}
