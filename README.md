# ADD

## 사용법
1. app 파일에 있는 app.zip 제거
2. 터미널에 dart run serious_python:main package app/src --mobile 입력
3. app/app.zip 파일이 생겼는지 확인
4. 필요한 라이브러리 등 설치
5. 프로젝트 실행

## 문제점
flutter_3d_controller에서 .glb 파일을 url로 받아오는 과정에서 문제가 생김   
에러 코드: I/chromium(17156): [INFO:CONSOLE(557)] "SyntaxError: Unexpected token 'E', "[Errno 2] N"... is not valid JSON", source: http://127.0.0.1:36725/model-viewer.min.js (557)   
line 90, 91에서 src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb', 는 실행이 되지만   
src: 'http://127.0.0.1:8080/molecule.glb', 는 에러가 생김