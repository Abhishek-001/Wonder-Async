# Wonder-Async

An iOS HTTP Library written in Swift to download multiple images & other data Asynchronously and for iOS Engineers who want to implement Pinterest/ Instargram like smooth image loading in their iOS Applications.

Supports:
1. Asynchronous Multiple Requests
2. Configurable Cache that can be used to cache images.
3. Inbuilt Class CachedImageView that has loadUrl method for Asynchronously loading Images.
4. Cancel any request anytime by using this WebService's method -> WebService.sharedInstance.cancelTask(urlString: ) by providing url string.
5. Configurable CacheManager Class that can be used to cache data in-memory.

## Usage - CachedImageView
```
  // import Pod
  import Wonder_Async
  ...
  
  // make your imageviews object of CachedImageView
  @IBOutlet weak var popupImageView: CachedImageView!
  ....
  
  // use loadImage for loading Image in CachedImageView object 
  popupImageView.loadImage(urlString: "imageUrlString")
  
```

### Example
    Demo Example includes how to use library in your project. 
