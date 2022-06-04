class MovieProvider {
  int? displayPriority;
  String? logoPath;
  int? providerId;
  String? providerName;

  MovieProvider(
      {this.displayPriority,
      this.logoPath,
      this.providerId,
      this.providerName});

  MovieProvider.fromJson(Map<String, dynamic> json) {
    displayPriority = json['display_priority'];
    logoPath = json['logo_path'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
  }
}
