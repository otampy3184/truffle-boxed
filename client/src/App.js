import React, { Component } from "react";
//import SimpleStorageContract from "./contracts/SimpleStorage.json";
import MyToken from "./contracts/MyToken.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = { storageValue: null, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
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
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, contract } = this.state;

    // Stores a given value, 5 by default.
    //await contract.methods.set(5).send({ from: accounts[0] });
    //　自作のコントラクを呼び出して１００トークンミントする
    await contract.methods.mintToken("0x10f90666942D8FF04ad012728Db2434C0CE1d9a8", 122121).send({ from: accounts[0]});

    // Get the value from the contract to prove it worked.
    //const response = await contract.methods.get().call();
    //ミントされたトークンを確認する
    const response = await contract.methods.totalSupply().call();

    // Update state with the result.
    // response内に入っているトークン量をstorageValueに格納する
    this.setState({ storageValue: response });
    //this.setState({ storageValue: 120121002100 })
  };

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
}

export default App;
