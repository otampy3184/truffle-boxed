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

# フロントエンド(react)からGanacheの情報を取得して画面上に表示するまで

1. 独自トークンとしてMyToken.solを作成
ERC20準拠の超簡単なトークンコントラクトとしてMyTokenを作成
```javascript
// ERC20を継承した独自トークンを作成
contract MyToken is ERC20{
  ~~~
}
```

内部の処理としては、_totalSupplyとして全体の供給量を決め、mintToken機能で順次トークン量を増やしていく(**現状は初回の一度のみなので総供給量はいつも100**)
```javascript
    uint256 private _totalSupply;

    function mintToken(address recipient, uint256 initialSupply ) public {
        _totalSupply = initialSupply;

        _mint(recipient, initialSupply);
    }
```

ミントしたトークンはget()から取得できる
```javascript
    function get() public view returns (uint256) {
        return _totalSupply;
    }
```

2. truffleでコンパイル&マイグレート
truffleコマンドを使ってマイグレーションファイルを作り、マイグレート用の処理を記述していく
```
$ truffle create migration MyToken
```

```javascript
var MyToken = artifacts.require("./MyToken.sol");

module.exports = function(deployer) {
  deployer.deploy(MyToken);
};
```

マイグレートファイルができたらtruffle consoleからコンパイル＆マイグレート
```
& truffle console
> truffle compile --all
~~~
Compiled successfully using:
   - solc: 0.8.13+commit.abaa5c0e.Emscripten.clang
> truffle migrate --reset
~~~
Summary
=======
> Total deployments:   3
> Final cost:          0.03085172 ETH
```

3. react側
truffle unbox reactによってできたclientフォルダのApp.jsを編集していく

コンパイルされたMyToken.jsonをインポート
```javascript
import MyToken from "./contracts/MyToken.json";
```

web3系の接続処理は初期のままからそのまま使えるが、deployedNetworkで使うContractの名称などは変える必要がある
```javascript
try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = MyToken.networks[networkId];
      // const instance = new web3.eth.Contract(
      //   SimpleStorageContract.abi,
      //   deployedNetwork && deployedNetwork.address,
      // );
      const instance = new web3.eth.Contract(
        MyToken.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
```

非同期処理としてrunExample関数の中からチェーンからのデータを取得している
```javascript
  runExample = async () => {
    const { accounts, contract } = this.state;

    // Stores a given value, 5 by default.
    //await contract.methods.set(5).send({ from: accounts[0] });
    //　自作のコントラクを呼び出して１００トークンミントする
    await contract.methods.mintToken("0x10f90666942D8FF04ad012728Db2434C0CE1d9a8", 122121).send({ from: accounts[0]});

    // Get the value from the contract to prove it worked.
    //const response = await contract.methods.get().call();
    //ミントされたトークンを確認する
    const response = await contract.methods.get().call();

    // Update state with the result.
    // response内に入っているトークン量をstorageValueに格納する
    this.setState({ storageValue: response });
    //this.setState({ storageValue: 120121002100 })
  };
```

runExampleの結果はstateの中に格納され、最終的にrenderの中で表示される
```javascript
  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>My very first Token!!!!!</h1>
        <p>
          ERC20準拠のトークンをミントして、画面上に表示↓↓↓
        </p>
        <div>total amounts of hehe-token are ... {this.state.storageValue}-sorry</div>
      </div>
    );
  }
```

# truffleのコマンド
マイグレーションファイルを追加したい場合は下記実行することでマイグレーションファイルの雛形を勝手に作ってくれる（ファイル名の先頭は作成時点のタイムスタンプ）
```
$ truffle create migration <anyname>
```

contractを追加したい場合は下記実行することで自動でcontractファイルを作ってくれる
```
$ truffle create contract <anyname>
```

truffle consoleの起動
```
$ truffle console
```

consoleに入らなくても普通にCLIからTruffleコマンドを動かすことも可能
```
$ truffle migrate
$ truffle compile
```

コンパイル時に、全ファイル一括でコンパイルする際は--allオプションが使える
```
$ truffle compile --all
```

マイグレート時、もう一度最初からマイグレーションを行いたいときは--resetオプションをつける
```
$ truffle migrate --reset
```

truffle initを使えば基本のプロジェクトが作成される
```
$ truffle init
```