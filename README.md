# truffle boxを使ってみる
truffle box => 簡単にフルスタックのdappを作れるフレームワーク

# how to start
初期設定
```
mkdir truffle-boxed
cd truffle-boxed
truffle unbox react
```
unboxするフォルダが空でなかった場合は動かないので注意

truffle-configs.jsのnetwork部分をganacheのポート番号に変更する
```javascript
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
  }
```

tuffleからマイグレートを行う
```
truffle migrate
```

フロントエンド起動
```
cd client
yarn start
```

http://localhost:3000/に接続するとMetamaskが起動し、トランザクションへの承認を求められる

トランザクションはMetamaskに登録したGanache上のアカウントを指定する
送信先のアドレスはデプロイしたコントラクトアドレスになっている
初期状態ではコントラクトアドレスの残高は0となっておりフロントエンド上の表示も0になっているが、トランザクションの承認を行うと残高が追加される

追加された残高は以下の部分を通じてチェーン上からフロントエンド上に渡されている
```javascript
    // Stores a given value, 5 by default.
    await contract.methods.set(5).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.get().call();

    // Update state with the result.
    this.setState({ storageValue: response });
```

setState()によってresponseに入っているvalue値が格納され、HTML上に表示される
```html
        <div>The stored value is: {this.state.storageValue}</div>
```

初回起動以降は以下のコマンドでtruffleコンソールとフロントエンドを起動できる
```
$ truffle console
$ cd client
$ yarn start
```

ソースコード更新後は以下を行なって更新を適用する
```
$ truffle compile
$ truffle migrate
$ cd client
$ npm run build
```

ネットワーク立ち上げ後、truffleのコンソール内で以下を叩けばtestスクリプトを実行できる
```
> test 
```