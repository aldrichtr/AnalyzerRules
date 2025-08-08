
enum StringCase {
    None     = 0  # None specified
    Lower    = 1  # All letters are lowercase, no separator
    #             # advancedsystempropertycollection
    Upper    = 2  # All letters are uppercase, no separator
    #             # ADVANCEDSYSTEMPROPERTYCOLLECTION
    Capital  = 3  # First letter is uppercase, the rest are lowercase, no separator
    #             # Advancedsystempropertycollection
    Camel    = 4  # first word is lowercase, the remaining are capital case, no separator
    #             # advancedSystemPropertyCollection
    Pascal   = 5  # All words are capital case, no separator
    #             # AdvancedSystemPropertyCollection
    Snake    = 6  # All words are lowercase, '_' as separator
    #             # advanced_system_property_collection
    Kebab    = 7  # All words are lowercase, '-' as separator
    #             # advanced-system-property-collection
    Dot      = 8  # All words are lowercase, '.' as separator
    #             # advanced.system.property.collection
    Constant = 9  # All words are uppercase, '_' as separator
    #             # ADVANCED_SYSTEM_PROPERTY_COLLECTION
    Train    = 10 # All words are capital case, '-' as separator
    #             # Advanced-System-Property-Collection
    Cobol    = 11 # All words are uppercase, '-' as separator
    #             # ADVANCED-SYSTEM-PROPERTY-COLLECTION
}
