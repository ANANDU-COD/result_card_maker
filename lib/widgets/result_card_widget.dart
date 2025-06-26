import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultCardWidget extends StatefulWidget {
  final String name;
  final String location;
  final int mark;
  final String examName;
  final String examYear;
  final ImageProvider image;

  const ResultCardWidget({
    super.key,
    required this.name,
    required this.location,
    required this.mark,
    required this.examName,
    required this.examYear,
    required this.image,
  });

  @override
  State<ResultCardWidget> createState() => _ResultCardWidgetState();
}

class _ResultCardWidgetState extends State<ResultCardWidget> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _isDownloading = false;

  Future<void> _downloadCard() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final blob = html.Blob([pngBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "result_card.png")
          ..click();
        html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double width = 560;
    const double height = 560;

    return SingleChildScrollView(
      child: Column(
        children: [
          RepaintBoundary(
            key: _repaintKey,
            child: Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 13),
                    child: Text(
                      widget.examName.toUpperCase(),
                      style: GoogleFonts.bangers(
                        fontSize: 33,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.examYear,
                    style: GoogleFonts.anton(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/golden_circle.png', width: 210),
                      CircleAvatar(
                        radius: 65,
                        backgroundImage: widget.image,
                      ),
                    ],
                  ),
                  Text(
                    widget.name.toUpperCase(),
                    style: GoogleFonts.jost(
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 30),
                      Text(
                        '${widget.mark}%',
                        style: GoogleFonts.fugazOne(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Congratulations',
                    style: GoogleFonts.dancingScript(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _isDownloading ? null : _downloadCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: const Icon(Icons.download, color: Colors.white),
            label: Text(
              _isDownloading ? 'Downloading...' : 'Download Card',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
