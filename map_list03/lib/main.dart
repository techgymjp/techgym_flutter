import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// main関数
void main() {
  runApp(myMap());
}

// Stateless Widgetを継承したmyMppクラス
class myMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapView(),
    );
  }
}

// Stateful Widgetを継承したMapViewクラス。Stateful Widgetの生成
class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}
// 生成されたStateful WidgetのMapViewクラスを実行するためのメインとなる実行用クラス（_MapViewState）
class _MapViewState extends State<MapView> {
  // マップビューの初期位置
  CameraPosition _initialLocation = CameraPosition(target: LatLng(35.68145403034362, 139.76707116150914), zoom: 16);

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを決定する
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        // AppBarを表示し、タイトルも設定
        appBar: AppBar(
          title: Text('Flutter Map'),
        ),

        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
            ),
          ],
        ),
      ),
    );
  }
}