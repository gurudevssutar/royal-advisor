class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final String id;
  final String title;
  final String urlImage;
  final int arrivalTime;
  final int executeTime;

  const DraggableListItem(
      {
        required this.id,
        required this.title,
      required this.urlImage,
      required this.arrivalTime,
      required this.executeTime});
}
