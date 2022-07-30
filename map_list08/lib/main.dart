import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder2/geocoder2.dart';

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
  CameraPosition _initialLocation = CameraPosition(
      target: LatLng(35.68145403034362, 139.76707116150914), zoom: 16);

  // マップの表示制御用
  late GoogleMapController mapController;

  // マーカーリスト保存用
  List<Marker> myMarker = [];

  // マーカー住所保存用
  List<GeoData> location_data = [];

  // 共有したい住所情報の記録用変数
  String shared_address = 'no address';

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
                            CameraUpdate.newCameraPosition(_initialLocation),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 住所一覧表示画面
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black38),
                    width: width * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                height: 150, // 高さ指定
                                child: ListView.builder(
                                    itemCount: location_data.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            location_data[index].address ?? ''),
                                        textColor: Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (location_data.length > 0) {
                                              shared_address =
                                                  location_data[index].address;

                                              print(
                                                  '${location_data.length}, ${index}, ${shared_address}');

                                              mapController.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                      target: LatLng(
                                                          location_data[index]
                                                              .latitude,
                                                          location_data[index]
                                                              .longitude),
                                                      zoom: 18),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                      );
                                    })),
                          ]),
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

  // 経度・緯度を住所に変換
  Future<GeoData> getLocation(Marker data_marker) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: data_marker.position.latitude,
        longitude: data_marker.position.longitude,
        googleMapApiKey: "Your_API_Key");
    return data;
  }

  // マップをクリックした時にマーカーをリストに追加
  _handleTap(LatLng tappedPoint) async {
    late LatLng iniPos;
    late LatLng endPos;
    Marker marker_tmp = Marker(
      markerId: MarkerId(tappedPoint.toString()),
      position: tappedPoint,
      draggable: true,
      onDragStart: (iniPosition) {
        iniPos = iniPosition;
      },
      onDragEnd: (endPosition) {
        endPos = endPosition;
      },
    );

    getLocation(marker_tmp).then((GeoData location_tmp) {
      setState(() {
        myMarker.add(marker_tmp);
        location_data.add(location_tmp);
        print(location_tmp);
      });
    });
  }
}
