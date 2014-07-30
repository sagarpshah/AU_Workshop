1) Use AFNetworking - https://github.com/AFNetworking/AFNetworking - to call the Parse REST API.

2) We will create AFNetworking client in a singleton pattern.

3) Create new file SDAFParseAPIClient which is a subclass of AFHTTPClient.

4) Replace YOUR_APPLICATION_ID and YOUR_REST_API_KEY with the values of your app Settings.

5) SDAFParseAPIClient creates three static NSString variables for the Parse API URL, your Parse API Application Id, and your Parse API Key, and implements the + (SDAFParseAPIClient *)sharedClient method which uses GCD to create a new instance of the class and store its reference in a static variable, thus becoming a Singleton.

6) #import "AFJSONRequestOperation.h"

7) Important to understand parse REST API implementation - https://parse.com/docs/rest#objects-retrieving

8) - (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters
will return an NSMutableURLRequest used to GET records from the Parse API for a Parse Object with the class name ‘className’ and submit an NSDictionary of parameters.

9) - (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate
will return an NSMutableURLRequest used to GET records from the Parse API that were updated after a specified NSDate. Notice that this method creates the parameters dictionary and calls your other method. This is merely a convenience method so that the parameters dictionary does not have to be generated each time a request is made using a date.
