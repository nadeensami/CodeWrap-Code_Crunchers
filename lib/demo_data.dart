class Repo {
  final String user;
  final String name;
  final bool isNight;
  final int nightPercent;

  Repo(this.user, this.name, this.isNight, this.nightPercent);
}

class DemoData {
  static final List<Repo> _repos = [
    Repo("TheThirdOnes", "rars", false, 54),
    Repo("LoopKit", "Loop", true, 98),
  ];

  static List<Repo> getRepos() => _repos;
}
