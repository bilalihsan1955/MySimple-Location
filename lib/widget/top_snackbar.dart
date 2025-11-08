import 'package:flutter/material.dart';

class TopSnackbar {
  static void tampilkan(
    BuildContext context, {
    required String pesan,
    Color? warnaLatarBelakang,
    IconData? ikon,
    Duration durasi = const Duration(seconds: 3),
    VoidCallback? onpressed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entriOverlay;
    bool sudahDitutup = false;

    void tutup() {
      if (sudahDitutup) return;
      sudahDitutup = true;
      if (entriOverlay.mounted) {
        entriOverlay.remove();
      }
    }

    entriOverlay = OverlayEntry(
      builder: (context) => _WidgetSnackbarAtas(
        pesan: pesan,
        warnaLatarBelakang: warnaLatarBelakang,
        ikon: ikon,
        onpressed: onpressed,
        onclosed: tutup,
        onswap: tutup,
      ),
    );

    overlay.insert(entriOverlay);

    // Auto remove after duration
    Future.delayed(durasi, () {
      tutup();
    });
  }

  // Helper methods for common use cases
  static void tampilkanSukses(
    BuildContext context,
    String pesan, {
    Duration durasi = const Duration(seconds: 3),
  }) {
    tampilkan(
      context,
      pesan: pesan,
      warnaLatarBelakang: Colors.green,
      ikon: Icons.check_circle,
      durasi: durasi,
    );
  }

  static void tampilkanError(
    BuildContext context,
    String pesan, {
    Duration durasi = const Duration(seconds: 4),
  }) {
    tampilkan(
      context,
      pesan: pesan,
      warnaLatarBelakang: Colors.red,
      ikon: Icons.error,
      durasi: durasi,
    );
  }

  static void tampilkanInfo(
    BuildContext context,
    String pesan, {
    Duration durasi = const Duration(seconds: 3),
  }) {
    tampilkan(
      context,
      pesan: pesan,
      warnaLatarBelakang: Colors.blue,
      ikon: Icons.info,
      durasi: durasi,
    );
  }

  static void tampilkanPeringatan(
    BuildContext context,
    String pesan, {
    Duration durasi = const Duration(seconds: 3),
  }) {
    tampilkan(
      context,
      pesan: pesan,
      warnaLatarBelakang: Colors.orange,
      ikon: Icons.warning,
      durasi: durasi,
    );
  }
}

class _WidgetSnackbarAtas extends StatefulWidget {
  final String pesan;
  final Color? warnaLatarBelakang;
  final IconData? ikon;
  final VoidCallback? onpressed;
  final VoidCallback onclosed;
  final VoidCallback onswap;

  const _WidgetSnackbarAtas({
    required this.pesan,
    this.warnaLatarBelakang,
    this.ikon,
    this.onpressed,
    required this.onclosed,
    required this.onswap,
  });

  @override
  State<_WidgetSnackbarAtas> createState() => _StateWidgetSnackbarAtas();
}

class _StateWidgetSnackbarAtas extends State<_WidgetSnackbarAtas>
    with SingleTickerProviderStateMixin {
  late AnimationController pengontrolAnimasi;
  late Animation<Offset> animasiGeser;
  late Animation<double> animasiFade;

  @override
  void initState() {
    super.initState();
    pengontrolAnimasi = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 250),
    );

    animasiGeser = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: pengontrolAnimasi,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    animasiFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: pengontrolAnimasi,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    pengontrolAnimasi.forward();
  }

  @override
  void dispose() {
    pengontrolAnimasi.dispose();
    super.dispose();
  }

  void _handleTutup() {
    pengontrolAnimasi.reverse().then((_) {
      widget.onclosed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: animasiGeser,
          child: FadeTransition(
            opacity: animasiFade,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.onpressed,
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -5) {
                    // Swipe up
                    _handleTutup();
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.warnaLatarBelakang ?? Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (widget.ikon != null) ...[
                        Icon(widget.ikon, color: Colors.white, size: 20),
                        SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          widget.pesan,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: _handleTutup,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
