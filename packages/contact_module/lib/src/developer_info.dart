class DeveloperInfo {
  final String name;
  final String email;
  final String playStoreUrl;

  const DeveloperInfo({
    required this.name,
    required this.email,
    required this.playStoreUrl,
  });
}

class DeveloperDataManager {
  static DeveloperInfo getDeveloperInfo() {
    return const DeveloperInfo(
      name: "HJoon", // TODO: 실제 개발자명
      email: "devapp.hjoon@gmail.com", // TODO: 실제 이메일
      playStoreUrl: "https://play.google.com/store/apps/developer?id=HJoon",
    );
  }
}
