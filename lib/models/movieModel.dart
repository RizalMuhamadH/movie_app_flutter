class Movie {
  List<Results> _results;
  int _page;
  int _totalResults;
  Dates _dates;
  int _totalPages;

  Movie(
      {List<Results> results,
        int page,
        int totalResults,
        Dates dates,
        int totalPages}) {
    this._results = results;
    this._page = page;
    this._totalResults = totalResults;
    this._dates = dates;
    this._totalPages = totalPages;
  }

  List<Results> get results => _results;
  set results(List<Results> results) => _results = results;
  int get page => _page;
  set page(int page) => _page = page;
  int get totalResults => _totalResults;
  set totalResults(int totalResults) => _totalResults = totalResults;
  Dates get dates => _dates;
  set dates(Dates dates) => _dates = dates;
  int get totalPages => _totalPages;
  set totalPages(int totalPages) => _totalPages = totalPages;

  Movie.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      _results = new List<Results>();
      json['results'].forEach((v) {
        _results.add(new Results.fromJson(v));
      });
    }
    _page = json['page'];
    _totalResults = json['total_results'];
    _dates = json['dates'] != null ? new Dates.fromJson(json['dates']) : null;
    _totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._results != null) {
      data['results'] = this._results.map((v) => v.toJson()).toList();
    }
    data['page'] = this._page;
    data['total_results'] = this._totalResults;
    if (this._dates != null) {
      data['dates'] = this._dates.toJson();
    }
    data['total_pages'] = this._totalPages;
    return data;
  }
}

class Results {
  int _voteCount;
  int _id;
  bool _video;
  double _voteAverage;
  String _title;
  double _popularity;
  String _posterPath;
  String _originalLanguage;
  String _originalTitle;
  List<int> _genreIds;
  String _backdropPath;
  bool _adult;
  String _overview;
  String _releaseDate;
  int heroTag;

  Results(
      {int voteCount,
        int id,
        bool video,
        double voteAverage,
        String title,
        double popularity,
        String posterPath,
        String originalLanguage,
        String originalTitle,
        List<int> genreIds,
        String backdropPath,
        bool adult,
        String overview,
        String releaseDate}) {
    this._voteCount = voteCount;
    this._id = id;
    this._video = video;
    this._voteAverage = voteAverage;
    this._title = title;
    this._popularity = popularity;
    this._posterPath = posterPath;
    this._originalLanguage = originalLanguage;
    this._originalTitle = originalTitle;
    this._genreIds = genreIds;
    this._backdropPath = backdropPath;
    this._adult = adult;
    this._overview = overview;
    this._releaseDate = releaseDate;
  }

  int get voteCount => _voteCount;
  set voteCount(int voteCount) => _voteCount = voteCount;
  int get id => _id;
  set id(int id) => _id = id;
  bool get video => _video;
  set video(bool video) => _video = video;
  double get voteAverage => _voteAverage;
  set voteAverage(double voteAverage) => _voteAverage = voteAverage;
  String get title => _title;
  set title(String title) => _title = title;
  double get popularity => _popularity;
  set popularity(double popularity) => _popularity = popularity;
  String get posterPath => _posterPath;
  set posterPath(String posterPath) => _posterPath = posterPath;
  String get originalLanguage => _originalLanguage;
  set originalLanguage(String originalLanguage) =>
      _originalLanguage = originalLanguage;
  String get originalTitle => _originalTitle;
  set originalTitle(String originalTitle) => _originalTitle = originalTitle;
  List<int> get genreIds => _genreIds;
  set genreIds(List<int> genreIds) => _genreIds = genreIds;
  String get backdropPath => _backdropPath;
  set backdropPath(String backdropPath) => _backdropPath = backdropPath;
  bool get adult => _adult;
  set adult(bool adult) => _adult = adult;
  String get overview => _overview;
  set overview(String overview) => _overview = overview;
  String get releaseDate => _releaseDate;
  set releaseDate(String releaseDate) => _releaseDate = releaseDate;

  Results.fromJson(Map<String, dynamic> json) {
    _voteCount = json['vote_count'];
    _id = json['id'];
    _video = json['video'];
//    _voteAverage = json['vote_average'];
    _title = json['title'];
    _popularity = json['popularity'];
    _posterPath = json['poster_path'];
    _originalLanguage = json['original_language'];
    _originalTitle = json['original_title'];
    _genreIds = json['genre_ids'].cast<int>();
    _backdropPath = json['backdrop_path'];
    _adult = json['adult'];
    _overview = json['overview'];
    _releaseDate = json['release_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_count'] = this._voteCount;
    data['id'] = this._id;
    data['video'] = this._video;
    data['vote_average'] = this._voteAverage;
    data['title'] = this._title;
    data['popularity'] = this._popularity;
    data['poster_path'] = this._posterPath;
    data['original_language'] = this._originalLanguage;
    data['original_title'] = this._originalTitle;
    data['genre_ids'] = this._genreIds;
    data['backdrop_path'] = this._backdropPath;
    data['adult'] = this._adult;
    data['overview'] = this._overview;
    data['release_date'] = this._releaseDate;
    return data;
  }
}

class Dates {
  String _maximum;
  String _minimum;

  Dates({String maximum, String minimum}) {
    this._maximum = maximum;
    this._minimum = minimum;
  }

  String get maximum => _maximum;
  set maximum(String maximum) => _maximum = maximum;
  String get minimum => _minimum;
  set minimum(String minimum) => _minimum = minimum;

  Dates.fromJson(Map<String, dynamic> json) {
    _maximum = json['maximum'];
    _minimum = json['minimum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maximum'] = this._maximum;
    data['minimum'] = this._minimum;
    return data;
  }
}