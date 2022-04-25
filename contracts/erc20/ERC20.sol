// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./extensions/IERC20Metadata.sol";
import "../utils/Context.sol";

// それぞれのインターフェースの中でinplementできていないものが一つでもあった場合は"contract should be marked as abstract"というエラーが出る
contract ERC20 is Context, IERC20, IERC20Metadata {
    // addressとintを組み合わせてBalance情報とする
    // erc20トークンの本質的な残高管理はこの変数で行われる
    // 所有者のアドレスとトークン残高(balance)を紐づけたデータを管理するスマートコントラクト
    // 各ユーザーが「価値のあるトークンをどのくらい所有しているか」を管理しているのがトークンコントラクトであるといえる
    mapping(address => uint256) private _balances;
    // addressとaddress+uint256を合わせて移転許容量の情報とする
    // allowance(owner, spender)
    // Tokenの所持者はownerで、実際に移転するのがspender
    mapping(address => mapping(address => uint256)) private _allowance;

    uint256 private _totalSupply;

    // 人間が読めるトークンの名前（米ドルなど）
    string private _name;
    // 人間が読めるトークンの記号（USDなど）
    string private _symbol;

    // コントラクト実行時に渡されたnameとsymbolをコントラクト内の値として設定する
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // コンストラクターで設定されたnameを返す
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    // コンストラクタで設定されたsymbol値を返す
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    // decimal値はここで決定する
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    // 総供給量を返す
    function totalSupply() public view virtual override returns(uint256) {
        return _totalSupply;
    }

    // 特定アカウントの残高を返す
    // 指定されたアカウントの残高を返す
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    // コントラクトの呼び出し者から、toに対して移転を行う
    // transfer関数の呼び出しもとのアドレスから、指定されたアドレスに対してトークンを送る
    function transfer(address to, uint256 amount) public virtual override returns (bool){
        // msg.senderをownerとする
        address owner = _msgSender();
        // _transfer関数を呼び出して移転を行う
        _transfer(owner, to, amount);
        return true;
    }

    // コントラクトの呼び出し者が、spenderのamountを移転できる許可を与える
    // 受信者のアドレスとトークン量が指定されたら、承認を発行したアカウントから指定されたトークン金額を上限とする伏するうの送金を実行できるように、指定されたアドレスに権限を与える
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        // msg.senderをownerとする
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    // fromユーザーからtoユーザーに対してamount量の移転を行う
    // approve関数と組み合わせて使う
    function transferFrom(
        address from,
        address to,
        uint256 amount 
    ) public virtual override returns(bool) {
        // msg.senderをspenderとする
        address spender = _msgSender();
        // fromとspenderの間にallowanceを割り当てる
        _spendAllowance(from, spender, amount);
        // fromからtoに移転を行う
        _transfer(from, to, amount);
        // 処理としては最終的にtrueを返す
        return true;
    }

    // ownerに対するspenderのallowanceをaddedValueだけ増加させる
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns(bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    // ownerに対するspenderのallowanceをsubsstractValueだけ減少させる
    function decreaseAllowance(address spender, uint256 substractValue) public virtual returns(bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= substractValue, "ERC20: decrease allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance -substractValue);
        }

        return true;
    }

    // 所有者アドレスと使用者アドレスが指定されたら、使用者が所有者アドレスから引き出すことができる金額を返す
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowance[owner][spender];
    }

    // amount量のトークンをaccountに対して新たに割り当てる
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    // amount量のトークンをaccountから削除する
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        // 残高が下回っていないか確認し、アカウントのbalaanceを更新し、totalsupplyも更新する
        require(accountBalance >= amount, "ERC20: burn amount exceed balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }

        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }
 
    // fromからtoに対してamount量の資金をTransferする
    function _transfer(
        address from,
        address to,
        uint256 amount 
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceed balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    // amountをownerに対するspenderのallowanceに設定する
    function _approve (
        address owner,
        address spender, 
        uint256 amount
    ) internal virtual {
        // ownerまたはspenderはzero addressであってはならない
        require(owner != address(0), "ERC20: approve from zero address");
        require(spender != address(0), "ERC20: approve to zero address");

        // allowanceの新しい値を設定する
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // allowanceを更新する
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        // 現在のallowanceを確認
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            // 今のallowanceがspendする量より下回っていない場合は、差し引いた値を新たなallowanceにする
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    // token移転前に行う行う処理(未実装)
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount 
    ) internal virtual{}

    // token移転後に行う行う処理(未実装)
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount 
    ) internal virtual {}
}

