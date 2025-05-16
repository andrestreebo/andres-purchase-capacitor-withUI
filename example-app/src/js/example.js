import { ASBPurchasesUI } from 'asb-purchases-ui-capacitor';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    ASBPurchasesUI.echo({ value: inputValue })
}
