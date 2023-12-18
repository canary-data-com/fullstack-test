import React, { useState } from "react";
import { Title } from "./components/title";
import TradingForm from "./components/TradingForm"; // Import the TradingForm component

interface AppProps {
  name: string;
}

const App: React.FC<AppProps> = (props: AppProps) => {
  // Create a function to handle form submission
  const handleFormSubmit = (formData: FormData) => {
    // You can handle the form data submission logic here
    // For now, you can simply log the data to the console
    console.log(formData);
  };

  // Define the list of companies (replace with your actual list)
  const companies = ["AAPL", "GOOGL", "AMZN", "TSLA"];

  return (
    <div>
      <Title title="Trading Insider" />
      <TradingForm onSubmit={handleFormSubmit} companies={companies} />
    </div>
  );
};

export default App;