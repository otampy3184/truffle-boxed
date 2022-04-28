import React, { useState, useEffect, useSyncExternalStore } from "react";
import detectEthereumProvider from '@metamask/detect-provider';
import FundraiserFactoryContract from './contracts/FundraiserFactory.json';
import NFTFactoryContract from './contracts/NFTFactory.json';
import GnosisSafeProxyFactoryContract from './contracts/GnosisSafeProxyFactory.json';
import MyTokenFactoryContract from "./contracts/MyTokenFactory.json";
import Web3 from "web3";
import FundraiserCard from './fundraiser/FundraiserCard';
import NFTCard from "./nft/NFTCard";
import WalletCard from "./wallet/WalletCard";
import MyTokenCard from "./mytoken/MyTokenCard";
import UseStyles from "./common/useStyles";

const Home =() => {
    //const [funds, sendFunds ] = useSteta([]);
    const [myToken, setMyTokens ] = useSyncExternalStore([]);
    //const [ nfts, setNfts ] = useState ([]);
    //const [ wallets, setWallets ] = useState ([]) ;
    const [ contract, setContract ] = useState([]);
    //const [ account, setAccount ] = ([]);
    //const classes = useStyles();

    useEffect (() => {
        init();
    }, [])

    window.ethereum.on('accountsChanged', function (accounts) {
        window.location.reload()
    });

    const init = async => {
        try {
            const provider = await detectEthereumProvider();
            const web3 = new Web3(provider);
            const networkId = await web3.eth.net.getId();
            //const deployedNetwork = MyTokenFactoryContract.networks[networkId];
            const accounts = await web3.eth.getAccounts();
            //const instance = new web3.eth.Contract(MyTokenFactoryContract.abi, deployNetwork && deployNetwork.address);   
        } catch (error) {
            alert('failed to load web3, accouns, contract');
            console.log(error);
        }
    }
}