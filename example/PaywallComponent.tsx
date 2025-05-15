import React, { useEffect, useState } from 'react';
import { IonButton, IonCard, IonCardContent, IonCardHeader, IonCardTitle, IonContent, IonPage } from '@ionic/react';
import { Purchases } from '@revenuecat/purchases-capacitor';
import { PurchasesUI } from '@revenuecat/purchases-ui-capacitor';

interface PaywallProps {
  apiKey: string;
}

const PaywallComponent: React.FC<PaywallProps> = ({ apiKey }) => {
  const [initialized, setInitialized] = useState(false);
  const [purchaseResult, setPurchaseResult] = useState<string | null>(null);

  useEffect(() => {
    // Initialize RevenueCat on component mount
    const initializePurchases = async () => {
      try {
        await Purchases.configure({
          apiKey,
        });
        setInitialized(true);
      } catch (error) {
        console.error('Failed to initialize RevenueCat:', error);
      }
    };

    if (!initialized) {
      initializePurchases();
    }

    return () => {
      // Close any open paywalls on unmount
      PurchasesUI.closePaywall().catch(console.error);
    };
  }, [apiKey, initialized]);

  const showFullScreenPaywall = async () => {
    try {
      const result = await PurchasesUI.presentPaywall({
        offering: 'default',
        displayMode: 'fullScreen',
        colors: {
          accent: '#4c669f',
          text: '#333333',
          background: '#ffffff',
          secondaryBackground: '#f2f2f7'
        }
      });

      if (result.didPurchase) {
        setPurchaseResult(`Purchase completed successfully! Product: ${result.productIdentifier}`);
      } else {
        setPurchaseResult('Purchase was not completed');
      }
    } catch (error) {
      setPurchaseResult(`Error showing paywall: ${(error as Error).message}`);
    }
  };

  const showSheetPaywall = async () => {
    try {
      const result = await PurchasesUI.presentPaywall({
        offering: 'default',
        displayMode: 'sheet',
        colors: {
          accent: '#4c669f'
        }
      });

      if (result.didPurchase) {
        setPurchaseResult(`Purchase completed successfully! Product: ${result.productIdentifier}`);
      } else {
        setPurchaseResult('Purchase was not completed');
      }
    } catch (error) {
      setPurchaseResult(`Error showing paywall: ${(error as Error).message}`);
    }
  };

  const showFooterPaywall = async () => {
    try {
      const result = await PurchasesUI.presentFooterPaywall({
        offering: 'default'
      });

      if (result.didPurchase) {
        setPurchaseResult(`Purchase completed successfully! Product: ${result.productIdentifier}`);
      } else {
        setPurchaseResult('Purchase was not completed');
      }
    } catch (error) {
      setPurchaseResult(`Error showing footer paywall: ${(error as Error).message}`);
    }
  };

  const closePaywall = async () => {
    try {
      await PurchasesUI.closePaywall();
      setPurchaseResult('Paywall closed');
    } catch (error) {
      setPurchaseResult(`Error closing paywall: ${(error as Error).message}`);
    }
  };

  return (
    <IonPage>
      <IonContent>
        <div style={{ padding: 20 }}>
          <h1 style={{ textAlign: 'center' }}>RevenueCat Purchases UI Example</h1>
          
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            <IonButton 
              expand="block" 
              onClick={showFullScreenPaywall}
              disabled={!initialized}
            >
              Show Full Screen Paywall
            </IonButton>
            
            <IonButton 
              expand="block" 
              onClick={showSheetPaywall}
              disabled={!initialized}
            >
              Show Sheet Paywall
            </IonButton>
            
            <IonButton 
              expand="block" 
              onClick={showFooterPaywall}
              disabled={!initialized}
            >
              Show Footer Paywall
            </IonButton>
            
            <IonButton 
              expand="block" 
              color="medium" 
              onClick={closePaywall}
              disabled={!initialized}
            >
              Close Paywall
            </IonButton>
          </div>
          
          {purchaseResult && (
            <IonCard style={{ marginTop: 20 }}>
              <IonCardHeader>
                <IonCardTitle>Result</IonCardTitle>
              </IonCardHeader>
              <IonCardContent>
                {purchaseResult}
              </IonCardContent>
            </IonCard>
          )}
          
          {!initialized && (
            <IonCard style={{ marginTop: 20 }}>
              <IonCardHeader>
                <IonCardTitle>Status</IonCardTitle>
              </IonCardHeader>
              <IonCardContent>
                Initializing RevenueCat SDK...
              </IonCardContent>
            </IonCard>
          )}
        </div>
      </IonContent>
    </IonPage>
  );
};

export default PaywallComponent; 