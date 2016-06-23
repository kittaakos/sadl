/*WARNING: This document is auto-generated. DO NOT manually edit this file!
*   ==Generated by GenerateDocumentation based on appropriate .properties file==
*/

package com.ge.research.documentation;

import com.ge.research.messages.ErrorMessage;

public final class SadlErrorMessages {
/**
* Left and right sides of {0} are of incompatible types: {1} and {2}.
**/
    public static final ErrorMessage INCOMPATIBLE_MEMBER_TYPES = new ErrorMessage("incompatible_member_types");
/**
* Unexpected: Property has more than 2 restrictions.
**/
    public static final ErrorMessage PROPERTY_RESTRICTIONS = new ErrorMessage("property_restrictions");
/**
* '{0}' is expected to be a(n) {1} but it is not.
**/
    public static final ErrorMessage IS_NOT_A = new ErrorMessage("is_not_a");
/**
* Property '{0}' does not exist in the model.
**/
    public static final ErrorMessage PROPERTY_NOT_EXIST = new ErrorMessage("property_not_exist");
/**
* Unidentified expression.
**/
    public static final ErrorMessage UNIDENTIFIED = new ErrorMessage("unidentified");
/**
* Value of '{0}' is not in range of property '{1}'.
**/
    public static final ErrorMessage NOT_IN_RANGE = new ErrorMessage("not_in_range");
/**
* '{0}' is undefined. Please define the {1} before referencing it.
**/
    public static final ErrorMessage UNDEFINED = new ErrorMessage("undefined");
/**
* Unhandled {0} value: '{1}'
**/
    public static final ErrorMessage UNHANDLED = new ErrorMessage("unhandled");
/**
* A(n) {0} cannot be converted to a(n) {1}.
**/
    public static final ErrorMessage CANNOT_CONVERT = new ErrorMessage("cannot_convert");
/**
* This {0} is not an instance of a known type. It is: {1}
**/
    public static final ErrorMessage UNKNOWN_TYPE = new ErrorMessage("unknown_type");
/**
* '{0}' is a special reserved name. Please choose a different name.
**/
    public static final ErrorMessage RESERVED_NAME = new ErrorMessage("reserved_name");
/**
* Invalid property type: {0}.
**/
    public static final ErrorMessage INVALID_PROP_TYPE = new ErrorMessage("invalid_prop_type");
/**
* '{0}' is not a recognized {1} value.
**/
    public static final ErrorMessage UNKNOWN_VALUE = new ErrorMessage("unknown_value");
/**
* A(n) {0} requires a {1} but it is missing.
**/
    public static final ErrorMessage MISSING = new ErrorMessage("missing");
/**
* {0} could not be found, expected to be in '{1}'.
**/
    public static final ErrorMessage NOT_FOUND = new ErrorMessage("not_found");
/**
* Invalid Format: {0}.
**/
    public static final ErrorMessage INVALID_FORMAT = new ErrorMessage("invalid_format");
/**
* There can only be one {0} in a {1}.
**/
    public static final ErrorMessage ONLY_ONE = new ErrorMessage("only_one");
/**
* {0} should not be null.
**/
    public static final ErrorMessage INVALID_NULL = new ErrorMessage("invalid_null");
/**
* Cannot assign {0}: property '{1}' already has {0} assigned to '{2}'.
**/
    public static final ErrorMessage CANNOT_ASSIGN_EXISTING = new ErrorMessage("cannot_assign_existing");
/**
* A {0} with name '{1}' already exists in the set of {0}s. {0} names must be unique.
**/
    public static final ErrorMessage UNIQUE_NAME = new ErrorMessage("unique_name");
/**
* Member of {0} is an invalid type: {1}.
**/
    public static final ErrorMessage INVALID_MEMBER_TYPE = new ErrorMessage("invalid_member_type");
/**
* Cannot create unnamed instance with no class given.
**/
    public static final ErrorMessage CREATE_UNNAMED_INSTANCE = new ErrorMessage("create_unnamed_instance");
/**
* Unexpected value '{0}' ({1}) does not match expected range type {2}.
**/
    public static final ErrorMessage INCOMPATIBLE_RANGE = new ErrorMessage("incompatible_range");

}