#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h> 
#include <Foundation/Foundation.h> 

/* -----------------------------------------------------------------------------
   Step 1
   Set the UTI types the importer supports
  
   Modify the CFBundleDocumentTypes entry in Info.plist to contain
   an array of Uniform Type Identifiers (UTI) for the LSItemContentTypes 
   that your importer can handle
  
   ----------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
   Step 2 
   Implement the GetMetadataForFile function
  
   Implement the GetMetadataForFile function below to scrape the relevant
   metadata from your document and return it as a CFDictionary using standard keys
   (defined in MDItem.h) whenever possible.
   ----------------------------------------------------------------------------- */

/* -----------------------------------------------------------------------------
   Step 3 (optional) 
   If you have defined new attributes, update the schema.xml file
  
   Edit the schema.xml file to include the metadata keys that your importer returns.
   Add them to the <allattrs> and <displayattrs> elements.
  
   Add any custom types that your importer requires to the <attributes> element
  
   <attribute name="com_mycompany_metadatakey" type="CFString" multivalued="true"/>
  
   ----------------------------------------------------------------------------- */



/* -----------------------------------------------------------------------------
    Get metadata attributes from file
   
   This function's job is to extract useful information your file format supports
   and return it as a dictionary
   ----------------------------------------------------------------------------- */

Boolean GetMetadataForFile(void* thisInterface, 
			   CFMutableDictionaryRef attrs, 
			   CFStringRef contentTypeUTI,
			   CFStringRef pathToFile)
{
	NSDictionary *dictionary;
	NSMutableDictionary *attributes = attrs;
	NSAutoreleasePool *pool;
	pool = [[NSAutoreleasePool alloc] init];
	
	dictionary = [[NSDictionary alloc] initWithContentsOfFile:(NSString *)pathToFile];
	if (!dictionary) {
		[pool release];
		return NO;
	}
	[attributes setObject:[dictionary objectForKey:@"description"] forKey:(NSString *)kMDItemDisplayName];
	[attributes setObject:[dictionary objectForKey:@"tag"] forKey:(NSString *)kMDItemKeywords];
	if ([dictionary objectForKey:@"extended"]) {
		[attributes setObject:[dictionary objectForKey:@"extended"] forKey:(NSString *)kMDItemDescription];
	} else {
		[attributes setObject:@"" forKey:(NSString *)kMDItemDescription];
	}
	[attributes setObject:[dictionary objectForKey:@"time"] forKey:(NSString *)kMDItemContentCreationDate];
	[attributes setObject:[dictionary objectForKey:@"time"] forKey:(NSString *)kMDItemContentModificationDate];
	[attributes setObject:@"Del.icio.us Bookmark" forKey:(NSString *)kMDItemKind];
	[attributes setObject:[dictionary objectForKey:@"href"] forKey:@"kMDItemURL"];
	
	[pool release];
    return YES;
}
