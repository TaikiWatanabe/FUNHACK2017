extern "C" {
  #include "user_interface.h"
}

void setup() {
  Serial.begin(115200);
}

void loop() {
  int a0 = system_adc_read();   //TOUTのアナログ値取得
  float tmp = (a0 - 600) / 10;
  Serial.println(tmp);
  delay(300);

}
