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

  // マップの表示制御用
  late GoogleMapController mapController;

  // マーカーリスト保存用
  List<Marker> myMarker = [];

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
              markers: Set.from(myMarker),
              onTap: _handleTap,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),

            // ここからボタンを表示するためのコードを追加
            // ズームイン・ズームアウトのボタンを配置
            SafeArea(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // ズームインボタン
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // ボタンを押す前のカラー
                          child: InkWell(
                            splashColor: Colors.blue, // ボタンを押した後のカラー
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.add),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //　ズームアウトボタン
                      ClipOval(
                        child: Material(
                          color: Colors.blue.shade100, // ボタンを押す前のカラー
                          child: InkWell(
                            splashColor: Colors.blue, // ボタンを押した後のカラー
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.remove),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 画面を初期位置に移動
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  // 現在地表示ボタン
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // ボタンを押す前のカラー
                      child: InkWell(
                        splashColor: Colors.blue, // ボタンを押した後のカラー
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                                _initialLocation
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // マップをクリックした時にマーカーをリストに追加
  _handleTap(LatLng tappedPoint) async {
    late LatLng iniPos;
    late LatLng endPos;
    Marker marker_tmp = Marker(
      markerId: MarkerId(tappedPoint.toString()),
      position: tappedPoint,
    );

    setState(() {
      myMarker.add(marker_tmp);
    });
  }
}