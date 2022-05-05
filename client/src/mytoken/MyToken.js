import '../App.css';
import React, { useStete, useEffect} from 'react';
import MyTokenFacoryContract from '../contracts/MyTokenFactory.json';
import { makeStyles } from '@material-ui/core/styles';
import { Button, Select, MenuItem } from '@material-ui/core';
import FormControl from '@mui/material/FormControl';
import OutlinedInput from '@mui/material/OutlinedInput';
import InputLabel from '@mui/material/InputLabel';
import TextField from '@material-ui/core/TextField';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';

// 小数点指定
const Decimal = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

// useStyle関数
const useStyles = makeStyles ( theme => ({
    container : {
        dsiplay: 'flex';
        flexWrap: 'wrap',
    },
    button: {
        margin: {
            margin: theme.spacing(1);
        }
    }
}));

// MyTokenコンポーネント
const MyToken = () => {
    // ステート変数とセット用の関数を用意
    const [name, setName] = useState(null);
    const [symbol, setSymbol] = useState(null);
    const [decimal, setDecimal] = useStete(null);
    const [contract, setContract] = useState(null);
    const [accounts, setAccounts] = useState(null);
    const [netID, setNetID] = useState(null);
    const [ethWeb3, setEthWeb3] = useState(null);

    const classes = useStyles();

    useEffect (() => {
        init();
    }, []);

    const init = async() => {
        try {
            // ethereumのクライアントを設定
            const provider = await detectEthereumProvider();
            // Web3を設定
            const web3 = new Web3(provider);
            // web3インスタンスからネットワークIDを取得
            const networkId = await web3.eth.net.getId();
            // コントラクトがデプロイされたネットワークのIDを設定
            const deployedNetwork = MyTokenFacoryContract.networks[networkId];
            // メタマスクのアカウントを取得
            const web3Accounts = await web3.eth.getAccounts
            // インスタンス接続用のインスタンスを作成
            const instance = new web3.eth.Contract(MyTokenFacoryContract.abi, deployedNetwork && deployedNetwork.address);

            // state関数を使ってWeb3を設定する
            setEthWeb3(web3);
            // state関数を使ってコントラクトを使える状態にする
            setContract(instance);
            // アカウントを設定する
            setAccounts(web3Accounts);
            // ネットワークIDを設定する
            setNetID(networkId);
        } catch (error) {
            alert (`FAILED TO LOAD WEB3`);
            console.error(error);
        }
    };

    // buttonデプロイ関数
    const buttonDeploy = async() => {
        try {
            // コントラクトをデプロイする
            await contract.methods.createMyToken(name, symbol, decimal).send({
                from: accounts[0],
                gas: 650000
            });
            alert("MyTokenコントラクトデプロイ成功");
        } catch (e) {
            alert("MyTokenコントラクトデプロイ失敗")
            console.error(e);
        }
    };

    return (
        <>
        <h2>独自トークン作成画面（実装中）
        </h2>
        </>
    )
}