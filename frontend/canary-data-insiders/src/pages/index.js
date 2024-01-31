import Head from "next/head";
import { useState } from 'react';
import SearchBar from "@/components/SearchBar";
import TradingTable from "@/components/TradingTable";
import axios from 'axios';

export default function Home() {
  const [filterTicker, setFilterTicker] = useState('');
  const [tradingList, setTradingList] = useState([]);
  const [errorMessage, setErrorMessage] = useState('');

  async function handleSearchClick(e) {
    e.preventDefault();

    setTradingList([])

    if(filterTicker.length === 0) {
      setErrorMessage("Invalid ticker");
      return
    }
    
    try {
      const response = await axios.get(`http://localhost:4000/api/insiders/${filterTicker}/transactions`);
      setTradingList(response.data);
      setErrorMessage('')

    } catch (error) {
      console.log(error)
      setErrorMessage(error.message);
    }
    
  }

  return (
    <>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Generated by create next app" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <nav className="navbar navbar-expand-lg bg-body-tertiary">
        <div className="container-fluid">
          <a className="navbar-brand" href="#">Canary</a>
          <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className="collapse navbar-collapse" id="navbarSupportedContent">

            <SearchBar filterTicker={filterTicker} onFilterChange={setFilterTicker} onSearchClick={handleSearchClick} />
          </div>
        </div>
      </nav>
      <main className="container">
        {errorMessage && (
          <div className="alert alert-danger" role="alert">
          {errorMessage}
        </div>
        )}
        
        <TradingTable tradings={tradingList} />
      </main>
    </>
  );
}
