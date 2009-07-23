#import "ContentController.h"


@implementation ContentController

@synthesize content = _content, text = _text;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)orderAction:(NSString*)action {
  TTLOG(@"ACTION: %@", action);
}

- (void)showNutrition {
  TTOpenURL([NSString stringWithFormat:@"tt://food/%@/nutrition", self.content]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithWaitress:(NSString*)waitress query:(NSDictionary*)query {
  if (self = [super init]) {
    _contentType = ContentTypeOrder;
    self.content = waitress;
    self.text = [NSString stringWithFormat:@"%@ will take your order now.", waitress];

    self.title = @"Place Your Order";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
        initWithTitle:@"Order" style:UIBarButtonItemStyleDone
        target:@"tt://order/confirm" action:@selector(openURL)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
        initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered
        target:self action:@selector(dismiss)] autorelease];

    NSString* ref = [query objectForKey:@"ref"];
    TTLOG(@"ORDER REFERRED FROM %@", ref);
  }
  return self;
}

- (id)initWithFood:(NSString*)food {
  if (self = [super init]) {
    _contentType = ContentTypeFood;
    self.content = food;
    self.text = [NSString stringWithFormat:@"<b>%@</b> is just food, ya know?", food];

    self.title = food;
    self.navigationItem.rightBarButtonItem =
      [[[UIBarButtonItem alloc] initWithTitle:@"Nutrition" style:UIBarButtonItemStyleBordered
                                target:self action:@selector(showNutrition)] autorelease];
  }
  return self;
}

- (id)initWithNutrition:(NSString*)food {
  if (self = [super init]) {
    _contentType = ContentTypeNutrition;
    self.content = food;
    self.text = [NSString stringWithFormat:@"<b>%@</b> is healthy.  Trust us.", food];

    self.title = @"Nutritional Info";
  }
  return self;
}

- (id)initWithAbout:(NSString*)about {
  if (self = [super init]) {
    _contentType = ContentTypeNutrition;
    self.content = about;
    self.text = [NSString stringWithFormat:@"<b>%@</b> is the name of this page.  Exciting.", about];

    if ([about isEqualToString:@"story"]) {
      self.title = @"Our Story";
    } else if ([about isEqualToString:@"complaints"]) {
      self.title = @"Complaints Dept.";
    }
  }
  return self;
}

- (id)init {
  if (self = [super init]) {
    _contentType = ContentTypeNone;
    _content = nil;
    _text = nil;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_content);
  TT_RELEASE_SAFELY(_text);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  [super loadView];
  
  CGRect frame = CGRectInset(self.view.bounds, 20, 20);
  TTStyledTextLabel* label = [[[TTStyledTextLabel alloc] initWithFrame:frame] autorelease];
  label.tag = 42;
  label.font = [UIFont systemFontOfSize:22];
  [self.view addSubview:label];
  
  if (_contentType == ContentTypeNutrition) {
    self.view.backgroundColor = [UIColor grayColor];
    label.backgroundColor = self.view.backgroundColor;
    self.hidesBottomBarWhenPushed = YES;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  TTStyledTextLabel* label = (TTStyledTextLabel*)[self.view viewWithTag:42];
  label.html = _text;
}

@end
 