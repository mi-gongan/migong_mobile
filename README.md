# migong

## 웹뷰 성능 최적화

1. 웹은 CSR을 사용하여 초기 랜더링은 느리돼 그 이후는 앱처럼 빠른 UX를 가질 수 있도록 처리하였다
2. 초기 랜더링을 앱상에서 가리기 위해 "OffStage"라는 위젯을 Stack으로 웹뷰 위에 덮었다.
   => 유저한테는 OffStage(로그인 화면/splash)가 보이지만 뒤에서 랜더링이 되도록 할 수 있다.

---

## 로그인 로직

: 앱과 웹이 통신하는 과정에서 어떻게 안전하게 로그인을 작동시킬 것이냐가 관건이다.

- 우선 통신하는 과정에서는 javascript channel이 사용된다.
- 라이브러리는 webview_flutter를 사용하였다.
- 카카오톡 로그인을 사용하였다.
- 보안을 위해 nonce(랜덤값)과 state(request,logined,logout)이라는 변수를 사용하였다.

### 로그인

1. 카카오 로그인을 통해 받은 정보들과 "nonce(랜덤값)-37\*\*33", "상태(request)"를 파이어베이스에 세팅한다.
2. 그런 후 email과 nonce값을 붙인 링크로 웹뷰를 라우팅시킨 후 offState를 true로 하여 loginScreen을 stage에서 내린다.
3. 그럼 웹뷰에서는 그 email에 그 nonce가 매칭돼어있는지 체크하고 맞다면 상태를 logined를 바꿔준 후 우리에게 로그인된 화면으로 보여진다.
   => 이 상태에서는 더 이상 nonce를 사용하지 못한다 = 해킹하려면 로그인되는 5초 안에 37\*\*33의 확률로 nonce를 맞춰야한다.
4. 로그인된 email을 storage에 세팅한다.

### 로그아웃

1. 로그아웃을 누르면 파이어베이스에 상태를 "logout"으로 세팅
2. javascript 채널을 통해 offStage를 false로 세팅하여 loginScreen을 다시 띄어준다.

### 앱 처음 진입시

1. storage가 없다면 아무것도 x
2. storage에 email이 있다면 파이어베이스에서 데이터를 확인후 logined이면 바로 offStage를 true로 하여 webview로 넘어간다.
