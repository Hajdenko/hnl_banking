Locale = {
    Currency = '$',
    NotEnoughMoney = {
        Wallet = "You don't have enough money in your wallet!",
        Bank = "You don't have enough money in your bank account!",
        Type = 'error' -- notify
    },
    TextUi = {
        icon = 'bank',
        text = '[E] - Open Bank'
    },
    Context = {
        CloseContextOnRestart = "The Script for the bank is restarting. Im closing your menu.", -- notify when a player is in the context menu while the script is restarting, this is required because of the data.
        Title = 'Bank',
        TitleATM = 'ATM',

        OnlyNumbers = 'Only Numbers.',

        MoneyInBank = 'Bank: ',  -- THE SPACE IS REQUIRED
        MoneyInWallet = 'Wallet: ', -- THE SPACE IS REQUIRED
        MoneyIcon =  'money-bill-1-wave',
        MoneyIconColor = '#E0E6CD44',


        Withdraw = 'Withdraw',
        Withdraw_desc = 'Withdraw some cash from the bank', -- leave empty '' if you don't want to show description
        WithdrawATM = 'Withdraw',
        WithdrawIcon = 'arrow-up-from-bracket',
        WithdrawIconColor = 'white',
        Withdrawn = 'You have successfully withdrawn ', -- THE SPACE IS REQUIRED / successfully withdrawn.. cash .. Currency
        WithdrawHowMuch = 'How much do you want to withdraw?',
        FastWithdraw_desc = 'Quickly withdraw the chosen amount',


        Deposit = 'Deposit',
        Deposit_desc = 'Deposit some of your cash in the back',   -- leave empty '' if you don't want to show description
        DepositIcon = 'hand',
        DepositIconColor = '#DAA08D',
        Deposited = 'You have successfully deposited ', -- THE SPACE IS REQUIRED
        DepositHowMuch = 'How much do you want to deposit?',
        FastDeposit_desc = 'Quickly deposit the chosen amount',

        WelcomeMessage = {
            Hello = 'Hello, ',      -- THE SPACE IS REQUIRED
        }
    },
}

-- [ Czech ]
-- Locale = {
--     Currency = '$',
--     NotEnoughMoney = {
--         Wallet = 'Nemáte dostatek peněz ve vaší peněžence!',
--         Bank = 'Nemáte dostatek peněz na svém účtu v bance!',
--         Type = 'error'
--     },
--     TextUi = {
--         icon = 'bank',
--         text = '[E] - Otevřít Banku'
--     },
--     Context = {
--         CloseContextOnRestart = "Skript pro bankovnictví se restartuje. Zavírám vaše menu.",
--         Title = 'Banka',
--         TitleATM = 'Bankomat',

--         OnlyNumbers = 'Pouze čísla.',

--         MoneyInBank = 'Zůstatek: ',  -- THE SPACE IS REQUIRED
--         MoneyInWallet = 'Peněženka: ', -- THE SPACE IS REQUIRED
--         MoneyIcon =  'money-bill-1-wave',
--         MoneyIconColor = '#E0E6CD44',


--         Withdraw = 'Výběr',
--         Withdraw_desc = 'Výběr peněz z vaší banky', -- leave empty '' if you don't want to show description
--         WithdrawATM = 'Výběr z ATM',
--         WithdrawIcon = 'arrow-up-from-bracket',
--         WithdrawIconColor = 'white',
--         Withdrawn = 'Úspěšně jste vybrali ', -- THE SPACE IS REQUIRED
--         WithdrawHowMuch = 'Kolik si chceš vybrat peněz?',
--         FastWithdraw_desc = 'Rychle vyberte zvolenou částku',


--         Deposit = 'Vklad',
--         Deposit_desc = 'Vklad peněz do vaší banky',   -- leave empty '' if you don't want to show description
--         DepositIcon = 'hand',
--         DepositIconColor = '#DAA08D',
--         Deposited = 'Úspěšně jste vložili ', -- THE SPACE IS REQUIRED
--         DepositHowMuch = 'Kolik si chceš vložit peněz?',
--         FastDeposit_desc = 'Rychle vložte zvolenou částku',

--         WelcomeMessage = {
--             Hello = 'Ahoj, ',      -- THE SPACE IS REQUIRED
--         }
--     },
-- }