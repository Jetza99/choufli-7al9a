class YtVideo{
  String? videoId;
  String? videoTitle;
  /*String? videoUrl;*/

  YtVideo({this.videoId, this.videoTitle/*, this.videoUrl*/});

  YtVideo.fromJson(Map<String, dynamic> json){
    videoId = json['id']['videoId'];
    videoTitle = json['snippet']['title'];
    //videoUrl = json['snippet']['thumbnail']['medium']['url'];
  }

}