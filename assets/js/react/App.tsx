import React from "react";
import { Title } from "./components/Title";
import TradingForm from "./components/TradingForm";

interface AppProps {
  name: string;
}

const App: React.FC<AppProps> = (props: AppProps) => {
  return (
    <div>
      <Title title="Trading Report" />
      <TradingForm />
    </div>
  );
};

export default App;