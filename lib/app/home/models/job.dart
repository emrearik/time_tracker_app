class Job {
  final String id;
  String name;
  int ratePerHour;

  Job({required this.id, required this.name, required this.ratePerHour});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "ratePerHour": ratePerHour,
    };
  }

  factory Job.fromMap(Map<String, dynamic> data, String documentID) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(id: documentID, name: name, ratePerHour: ratePerHour);
  }
}
