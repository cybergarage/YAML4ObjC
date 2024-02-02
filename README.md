# YAML for ObjC

## Introduction

YAML4ObjC is a wrapper class for [LibYAML](http://pyyaml.org/wiki/LibYAML) [[1](#RefDoc01)] to query YAML data more easily on iOS platforms, iPhone and iPad.

I used LibYAML directly to read configuration files of YAML objects in my project for iOS, but it is hard to use in my projects because I had to write the handler function for each projects like SAX parsers for XML documents :-(

Thus, I aimed to handle YAML objects more easily only using Objective-C in the project and decided some implementation policies to handle YAML objects more easily for iOS developers as the following.

## Resources

- [GitHub](https://github.com/cybergarage/YAML4ObjC)
- [Doxygen](http://www.cybergarage.org:8080/doxygen/yaml4objc/)

### Using Only Standard iOS Objects

First, I would use only standard data objects of iOS such as NSArray and NSDictionary to hold YAML objects. After parsing YAML data using YAML4ObjC, the YAML nodes are translated into the following standard data structures in Objective-C on iOS.

YAML Node | iOS Object
---|---
Sequence | NSArray
Scalar | NSString

### YPath

Next, I would support simple methods to get the node values like XPath. I was looking for the public specification for YAML or JSON version of XPATH [[2](#RefDoc02)][[3](#RefDoc03)][[4](#RefDoc04)], but I could not find it yet :-( Thus, I thought the following simple ABNF specification like [XPath](http://www.w3.org/TR/xpath/) to get the node objects or values in YAML document easily.

```
YPath = [DocumentNo] '/' NodePath
NodePath = Node / NodePath '/' Node
Node = SequenceNo / MappingKeyName
DocumentNo = '[' [0-9]+ ']'
SequenceNo = '[' [0-9]+ ']'
MappingKeyName = [a-zA-Z0-9 ]+
```

## Setup

### Getting SDK Package

1\. Get the SDK package from the following site.

- [GitHub](https://github.com/cybergarage/YAML4ObjC)

### Building and using example applications

1\. Extract YAML4ObjC as the following steps:

```
$ unzip YAML4ObjC.zip
```

2\. Add LibYAML package into the your SDK directory as the following
steps:

```
$ cd YamlObjCSDK
$ curl http://pyyaml.org/download/libyaml/yaml-0.1.3.tar.gz > yaml-0.1.3.tar.gz
$ tar xvfz yaml-0.1.3.tar.gz
$ mv yaml-0.1.3 libyaml
$ cd libyaml
$ ./configure
```

3\. Open the project file in examples/ios/xcode/YamlViewer.xcodeproj

4\. Build and Run app

### Adding YamlObjCSDK to your project

1\. Create your iOS project

2\. Add source files of YamlObjCSDK, CGYAML.h and CGYAML.m, to select
YamlObjCSDK/YamlObjCSDK directory.

3\. Add the following source files of libyaml.

```
libyaml/config.h
libyaml/src/api.c
libyaml/src/api.cdumper.c
libyaml/src/api.cemitter.c
libyaml/src/api.cloader.c
libyaml/src/api.cparser.c
libyaml/src/api.creader.c
libyaml/src/api.cscanner.c
libyaml/src/api.cwriter.c
```

3\. Add "libyaml" and "libyaml/include" into "Heade Search Paths" of your build setting.

4\. Add "-DHAVE\_CONFIG into "Other C Flags" of your build setting.

5\. Build and Run app

If you want to install LibYAML using the configure script, please use a
utility script file, yaml-configure-iosdev, as the following.

```
$ curl http://pyyaml.org/download/libyaml/yaml-0.1.3.tar.gz > yaml-0.1.3.tar.gz
$ tar xvfz yaml-0.1.3.tar.gz
$ cp yaml-configure-iosdev yaml-0.1.3
$ cd yaml-0.1.3
$ ./yaml-configure-iosdev
$ make
$ make install
```

## Classes

YAML4ObjC is composed of only a CGYAML class as the following. I provide some useful category methods for NSObject to check the node type of YAML too. Please check [the doxygen document](http://www.cybergarage.org:8080/doxygen/yaml4objc/) to know the classes in more detail.

```
@interface CGYAML : NSObject {
}
- (id)init;
- (id)initWithString:(NSString *)yamlString;
- (id)initWithPath:(NSString *)yamlPath;
- (id)initWithData:(NSData *)yamlData;
- (id)initWithURL:(NSURL *)yamlURL;

- (BOOL)parseWithString:(NSString *)yamlString error:(NSError **)error;
- (BOOL)parseWithPath:(NSString *)yamlPath  error:(NSError **)error;
- (BOOL)parseWithData:(NSData *)yamlData  error:(NSError **)error;
- (BOOL)parseWithURL:(NSURL *)yamlURL  error:(NSError **)error;

- (NSError *)error;

- (NSUInteger)numDocuments;
- (NSArray *)documents;

- (id)documentRootNodeAtIndex:(NSUInteger)index;

- (id)objectForYPath:(NSString *)yPath;
- (NSString *)valueForYPath:(NSString *)yPath;

- (BOOL)writeToFile:(NSString *)yPath;
@end

@interface NSObject(CGYAML)
- (BOOL) isYAMLSequenceNode;
- (BOOL) isYAMLScalarNode;
- (BOOL) isYAMLMappingNode;
@end
```

CGYAML offers two methods to get all values in the specified YAML data. In the first method, you can get the node values by traversing data
objects form the root object using YAML::documents or YAML::documentRootNodeAtIndex: as the following. To traverse the all values, please check the implementation of YAML::description in the source code.

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
for (id rootNode in [self documents]) {
    if ([rootNode isYAMLSequenceNode) {
        for (NSString *seqValue in rootNode) {
            ......
        }
    }
    else if ([rootNode isYAMLMappingNode) {
        for (NSString *mapKey in [rootNode allKeys]) {
            NSString *mapValue = [rootNode objectForKey: mapKey];
            ......
        }
    }
}
```

In the next method, you can use YPath to get the node values using YAML::objectForYPath: or YAML::valueForYPath: as the following.

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSArray *seqNode = [yaml objectForKey:@"/[0]/american"];
for (NSString *seqValue in seqNode) {
    ......
}
NSString *value = [yaml valueForYPath:@"/[0]/american/[0]"];
.....
```

## Programming Examples

Using some examples in [YAML 1.1 specification](http://yaml.org/spec/1.1/), the following examples show how to get node values in YAML data using CGYAML methods.

### Example 2.1 : Sequence of Scalars

#### YAML

```
- Sammy Sosa
- Ken Griffey
```

#### Using Standard Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSArray *seqNode = [yaml documentRootNodeAtIndex:0];
NSString *value0 = [seqNode objectAtIndex:0];
NSString *value1 = [seqNode objectAtIndex:1];
NSString *value2 = [seqNode objectAtIndex:2];
```

### Using YPath Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSString *value0 = [yaml valueForYPath:@"/[0]"];
NSString *value1 = [yaml valueForYPath:@"/[1]"];
NSString *value2 = [yaml valueForYPath:@"/[2]"];
```

### Example 2.2 : Mapping Scalars to Scalars

#### YAML

```
hr:  65    # Home runs
avg: 0.278 # Batting average
rbi: 147   # Runs Batted In
```

#### Using Standard Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSDictionary *mapNode = [yaml documentRootNodeAtIndex:0];
NSString *value0 = [mapNode objectForKey:@"hr"];
NSString *value1 = [mapNode objectForKey:@"avg"];
NSString *value2 = [mapNode objectForKey:@"rbi"];
```

### Using YPath Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSString *value0 = [yaml valueForYPath:@"/hr"];
NSString *value1 = [yaml valueForYPath:@"/avg"];
NSString *value2 = [yaml valueForYPath:@"/rbi"];
```

### Example 2.3 : Mapping Scalars to Sequences

#### YAML

```
american:
- Boston Red Sox
- Detroit Tigers
- New York Yankees
national:
- New York Mets
- Chicago Cubs
- Atlanta Braves
```

#### Using Standard Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSDictionary *mapNode = [yaml documentRootNodeAtIndex:0];
NSArray *seqNode = [mapNode objectForKey:@"american"];
NSString *american0 = [seqNode objectAtIndex:0];
NSString *american1 = [seqNode objectAtIndex:1];
NSString *american2 = [seqNode objectAtIndex:2];
NSArray *seqNode = [mapNode objectForKey:@"national"];
NSString *national0 = [seqNode objectAtIndex:0];
NSString *national1 = [seqNode objectAtIndex:1];
NSString *national2 = [seqNode objectAtIndex:2];
```

### Using YPath Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSString *american0 = [yaml valueForYPath:@"/american/[0]"];
NSString *american1 = [yaml valueForYPath:@"/american/[1]"];
NSString *american2 = [yaml valueForYPath:@"/american/[2]"];
NSString *national0 = [yaml valueForYPath:@"/national/[0]"];
NSString *national1 = [yaml valueForYPath:@"/national/[1]"];
NSString *national2 = [yaml valueForYPath:@"/national/[2]"];
```

### Example 2.4 : Sequence of Mappings

#### YAML

```
-
name: Mark McGwire
hr:   65
avg:  0.278
-
name: Sammy Sosa
hr:   63
avg:  0.288
```

#### Using Standard Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSArray *seqNode = [yaml documentRootNodeAtIndex:0];
NSDictionary *mapNode = [seqNode objectAtIndex:0];
NSString *value0n = [mapNode objectForKey:@"name"];
NSString *value0h = [mapNode objectForKey:@"hr"];
NSString *value0a = [mapNode objectForKey:@"avg"];
NSDictionary *mapNode = [seqNode objectAtIndex:1];
NSString *value1n = [mapNode objectForKey:@"name"];
NSString *value1h = [mapNode objectForKey:@"hr"];
NSString *value1a = [mapNode objectForKey:@"avg"];
```

### Using YPath Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSString *value0n = [yaml valueForYPath:@"/[0]/name"];
NSString *value0h = [yaml valueForYPath:@"/[0]/hr"];
NSString *value0a = [yaml valueForYPath:@"/[0]/avg"];
NSString *value1n = [yaml valueForYPath:@"/[1]/name"];
NSString *value1h = [yaml valueForYPath:@"/[1]/hr"];
NSString *value1a = [yaml valueForYPath:@"/[1]/avg"];
```

### Example 2.7 : Single Document with Two Comments

#### YAML

```
# Ranking of 1998 home runs
---
- Mark McGwire
- Sammy Sosa
- Ken Griffey

# Team ranking
---
- Chicago Cubs
- St Louis Cardinals
```

#### Using Standard Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....];
NSArray *seqNode = [yaml documentRootNodeAtIndex:0];
NSString *value00 = [seqNode objectAtIndex:0];
NSString *value01 = [seqNode objectAtIndex:1];
NSString *value02 = [seqNode objectAtIndex:2];
NSArray *seqNode = [yaml documentRootNodeAtIndex:1];
NSString *value10 = [seqNode objectAtIndex:0];
NSString *value10 = [seqNode objectAtIndex:1];
```

### Using YPath Methods

```
CGYAML *yaml = [[CGYAML alloc] initWithString:.....]
NSString *value00 = [yaml valueForYPath:@"[0]/[0]"];
NSString *value01 = [yaml valueForYPath:@"[0]/[1]"];
NSString *value02 = [yaml valueForYPath:@"[0]/[2]"];
NSString *value10 = [yaml valueForYPath:@"[1]/[0]"];
NSString *value11 = [yaml valueForYPath:@"[1]/[1]"];
```

## References

- [1] [LibYAML](http://pyyaml.org/wiki/!LibYAML)
- [2] [XML Matters: YAML improves on
XML](http://www.ibm.com/developerworks/xml/library/x-matters23.html)
- [3] [JSONPath - XPath for JSON](http://goessner.net/articles/JsonPath/)
- [4] [YAML4R](http://yaml4r.sourceforge.net/doc/)
