
enum StringCase {
    None     = 0  # None specified

    # SECTION Base string case types
    # All letters are lowercase, no separator  [ advancedsystempropertycollection ]
    Lower    = 1
    # All letters are uppercase, no separator  [ ADVANCEDSYSTEMPROPERTYCOLLECTION ]
    Upper    = 2
    # First letter is uppercase, the rest are lowercase, no separator [ Advancedsystempropertycollection ]
    Capital  = 3
    # !SECTION

    # first word is lowercase, the remaining are capital case, no separator [ advancedSystemPropertyCollection ]
    Camel    = 4

    # All words are capital case, no separator [ AdvancedSystemPropertyCollection ]
    Pascal   = 5

    # SECTION Words with separators
    # All words are lowercase, '_' as separator [ advanced_system_property_collection ]
    Snake    = 6

    # All words are lowercase, '-' as separator [ advanced-system-property-collection ]
    Kebab    = 7

    # All words are lowercase, '.' as separator [ advanced.system.property.collection ]
    Dot      = 8

    # All words are uppercase, '_' as separator [ ADVANCED_SYSTEM_PROPERTY_COLLECTION ]
    Constant = 9

    # All words are capital case, '-' as separator [ Advanced-System-Property-Collection ]
    Train    = 10

    # All words are uppercase, '-' as separator [ ADVANCED-SYSTEM-PROPERTY-COLLECTION ]
    Cobol    = 11
    # !SECTION
}
