#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <Bridge.h>
#include <HttpClient.h>
/*
// Arduino UNO の場合は、例えばデジタル入出力の 2 番, 3 番ピンを利用して
// ESP-WROOM-02 とシリアル通信するように設定します。
const byte rxPin = 2; // Wire this to Tx Pin of ESP8266
const byte txPin = 3; // Wire this to Rx Pin of ESP8266
HttpClient_ESP8266_AT httpClient(rxPin, txPin);
*/
void setup() {
    // PC と通信する HardwareSerial の baudrate を設定します。
    // ESP-WROOM-02 の baudrate とは関係ありません。
    Serial.begin(115200);

    // SSID と PASSWORD でアクセスポイントに接続します。
    // シリアル接続確認と WiFi 接続確認を行い、設定不備があれば出力します。
    while(true) {
        if(httpClient.statusAT()) { Serial.println("AT status OK"); break; }
        else Serial.println("AT status NOT OK");
        delay(1000);
    }
    while(true) { // 書き換えてください↓
        if(httpClient.connectAP("hakodate-miraikan", "hakodate010")) { Serial.println("Successfully connected to an AP"); break; }
        else Serial.println("Failed to connected to an AP. retrying...");
        delay(1000);
    }
    while(true) {
        if(httpClient.statusWiFi()) { Serial.println("WiFi status OK"); break; }
        else Serial.println("WiFi status NOT OK");
        delay(1000);
    }
}

void loop() {
    // ノイズの影響でリクエストに失敗することがあるため while ループで囲います。
    while(true) {
        // HTTP POST リクエストを実行します。
        httpClient.post("https://rsserver.herokuapp.com", "/", "name=hoge%27hoge&val=123", "application/x-www-form-urlencoded");

        // レスポンス status code が 0 以上であればリクエスト成功です。
        //   -1: ノイズ等でシリアル通信ができず、そもそもデータ送信ができなかった。
        //    0: データ送信はできたが、受信データがノイズで壊れてしまっていた。
        //   else (>0): 受信データから正常に HTTP レスポンス status code が得られた。

        if(httpClient.responseStatusCode() >= 0) {
            // 本ページでは電圧レベルコンバータを用意していない想定のため、
            // 受信データが壊れている可能性が高く、したがって 200 が 100 になっていたりするため、
            // 値には興味をもたず、0 以上の値が得られることが重要であると考えてコーディングします。
            Serial.println("SUCCESS");
            break; // 成功したので while を抜けます。
        }
        else {
            Serial.println("FAILURE, retrying...");
        }
    }

    // 本サンプルでは 1 秒毎に POST を繰り返します。
    delay(1000);
}
