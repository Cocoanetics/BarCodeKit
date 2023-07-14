Change Log
==========

This is the history of version updates.


Version 1.4.0

- NEW: Implemented Swift Package Manager support

Version 1.3.2

- FIXED: Podspec didn't specify that pod is iOS compatible
- FIXED: Some 9.4 warnings

Version 1.3.1

- ADDED: Option to specify explicit barcode size
- FIXED: Incorrectly named methods and comments not matching the class name

Version 1.3.0

- FIXED: Assertion failure when draing barcodes into graphics context with translated CTM
- ADDED: Error messages on barcode generation localized in English, Japanese and German
- ADDED: BCKCodeDrawingReduceBleedOption for reducing bleed on thermo printers 
- ADDED: POSTNET Implementation
- ADDED: PLANET Implementation
- ADDED: ISMN Implementation
- ADDED: Added additional range and length checks to ISBN and ISMN
- ADDED: Internal support for barcodes with partial bars
- ADDED: BCKCodeDrawingCaptionFontPointSizeOption for specifying caption font size
- ADDED: Share button to Demo which exports a PDF of any configured barcode via activity view
- CHANGED: Internal implemention from NSString to BCKBarString
- CHANGED: Migrated unit tests to XCTest

Version 1.2.0

- ADDED: Mac Compatibility
- ADDED: Demo App for Mac
- ADDED: Option to specify barcode image background color
- ADDED: Facing Identification Mark Code
- ADDED: EAN-2 and EAN-5 Supplements
- ADDED: Standard 2 of 5 Code
- ADDED: Pharmacode One-Track Code
- ADDED: Optimized Presentation for UPC-A
- ADDED: ISSN Code
- ADDED: ISBN Code
- CHANGED: Codes now check if they are able to encode content and return an error message with the reason if not

Version 1.1.0

- ADDED: Code 128 Implementation
- ADDED: Code 93 Full ASCII Implementation
- ADDED: Code 11 Implementation
- ADDED: Code 39 Variants mod 43, Full ASCII (with and without mod 43)
- ADDED: New drawing option for customizing the caption font
- FIXED: Caption descenders get cut off for lowercase ASCII characters
- CHANGED: Replaced caption drawing with Core Text
- CHANGED: All codes cache their code characters after creating them
- CHANGED: Demo App much improved

Version 1.0.1

- ADDED: Implementation for Interleaved 2 of 5 Code
