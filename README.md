# resource_iOS
Native mobile app for Resource

.h files -- declaring instance variables.
.m files -- implement methods.
##### inside .m files
* a '-' means it's an instance method.
* a '+' is a class method. You'll see a bunch of class methods I started using but ultimately decided instances were
going to be easier for controlling sessions so everythings slowly being converted.
* syntax is definitely kooky, so just a little rundown of how methods are formed. 
```
- (id)makeRequestForUser:(NSDictionary *)params toUrl:(NSUrl *)url {
  //Do whatever you gotta do inside here.
  // again, '-' means were in an insance method.
  // (id) is the return type. In iOS, 'id' is a generic data type. It can stand for anything. So if you have some
  // wildcard method that can be used for a bunch of different types of objects, you can return id and it will go through.
  // The '*' that you see everywhere is a pointer. Every variable, with exception of basic data types (int, char, etc.)
  // will have that star after it. I'll move onto how to call methods cause it's weird as hell at first.
}
```

####Call them methods up SAHN
So lets say I want to see if a string is equal to another string...
```
NSString *myFirstString = [[NSString alloc]initWithString: @"This is really cool!"];
NSString *mySecondString = [[NSString alloc]initWithString: @"This isn't!"];
//Also as a side note -- i'm doing alloc (allocate space in memory) and init (initialize the object) here,
// but most data types have convenience initalizers. Ill do an array, string, and dictionary (hash) below real quick.
NSString *myFirstFastString = @"WOAH THAT WAS EASY!";
NSAarray *superSlickArray = @[@"index zero!!", @"index one!!"];
NSDictionary *keyValuePairsYall = @{@"keyOne" : @"I'm a value!!", @"keyTwo" : @"So am I! Neat!"};
```
Got sidetracked. Back to comparing myFirstString and mySecondString.
```
I'll write a simple method to do it first. Then show how it's called.
-(BOOL)checkIfStringIsEqual:(NSString *)string {
  if ([self.text isEqualToString: string]) {
    return YES;
  }
  return NO;
}
Okay cool so we got that. Now calling it.

[myFirstString checkIfStringIsEqual: mySecondString];
It's all about brackets. It seems weird as shit at first but once you get it you kinda like it for some weird reason.
I'll put an example of a crazy one from a different project below this.
```
Found one from the comedy app parser. It takes a string and tries to find the src url of an <img> tag.
It checks before it's done with that if it's a youtube link instead. Idk why I wrote this forever ago its stupid.
But if it's got a youtube link it grabs the youtube still for the cell image. If all else fails it returns that @"splash.png"
which is just a placeholder if everything else didn't work. Check it out

```
- (NSString *)findFirstImgUrlInString:(NSMutableString *)string
{
    if (string == nil) {
        return @"https://pbs.twimg.com/profile_images/579834981515579393/dfH178BE.jpg";
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(src\\s*?=\\s*?['\"](.*?)['\"])"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:string
                                                     options:0
                                                       range:NSMakeRange(0, [string length])];
    
    if ([[string substringWithRange:[result rangeAtIndex:2]] rangeOfString:@"youtube"].location == NSNotFound){
        return [string substringWithRange:[result rangeAtIndex:2]];
    } else {
        NSString *fromString = [string substringWithRange:[result rangeAtIndex:2]];
        NSRegularExpression *embedID = [NSRegularExpression regularExpressionWithPattern:@"(/embed/(.*?)\\?)"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
        NSTextCheckingResult *result = [embedID firstMatchInString: fromString
                                                           options:0
                                                             range:NSMakeRange(0, fromString.length -1)];
        
        if (result) {
            return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/hqdefault.jpg",
                    [fromString substringWithRange:[result rangeAtIndex:2]]];
        }
    }
    return @"splash.png";
}
```
I will say though it's totally not uncommon to have a method look like this in Objective C. It gets a little ridiculous,
but I think since its pretty much C apple was just like fuck it lol it's fast as shit we dont care!
Also it's totally thumbs up for having super descriptive long method names. Which was super weird to me at first, but it's how
everyone does it and it does make things a lot easier when you're dealing with bigger projects.
I'm trying to remember if I forgot any of the basics. I don't know you guys know how to get in touch with me.








