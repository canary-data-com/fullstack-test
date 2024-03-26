import React, { useState, useEffect } from 'react';
import axios from 'axios';
import Dropdown from 'react-dropdown';
import 'react-dropdown/style.css';

const InsiderTrade = () => {
    const [stocks, setStocks] = useState([]);
    const [selectedOption, setSelectedOption] = useState('');
    const [options, setOptions] = useState([]);

    useEffect(() => {
        fetchOptions();
    }, []);

    useEffect(() => {
        if (selectedOption) {
            fetchData();
        }
    }, [selectedOption]);

    const fetchOptions = async () => {
        try {
            const response = await axios.get(`http://localhost:4000/api/companies`);

            const data = response.data.data.map(item => ({
                label: item.company_name,
                value: item.ticker
            }));

            setOptions(data);
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    };

    const fetchData = async () => {
        try {
            const response = await axios.get(`http://localhost:4000/api/insider_trades?ticker=${selectedOption}`);
            setStocks(response.data.data);
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    };

    const handleOptionChange = (option) => {
        setSelectedOption(option.value);
    };

    return (
        <div className="container">
            <div className="header">

                <img src={`https://avatars.githubusercontent.com/u/153301711?s=200&v=4`} alt="Company Logo" className="company-logo" />
                <h1 >Company Insider Trading Activity</h1>
            </div>
            <div className="dropdown-container">
                <Dropdown
                    id="company-dropdown"
                    options={options}
                    value={selectedOption}
                    onChange={handleOptionChange}
                    placeholder="Select a company to view insider trading activity"
                    controlClassName="dropdown-control"
                    menuClassName="dropdown-menu"
                    optionClassName="dropdown-option"
                    style={{
                        width: '200px',
                        borderRadius: '5px',
                        border: '1px solid #ccc',
                        backgroundColor: '#fff',
                    }}
                />
            </div>
            <table className="table">
                <thead>
                    <tr>
                        <th style={{ width: '30%' }}>Insider</th>
                        <th>Relation</th>
                        <th>Transaction Date</th>
                        <th>Share Quantity</th>
                        <th>% of Market Cap</th>
                    </tr>
                </thead>
                <tbody>
                    {stocks.map((stock, index) => (
                        <tr key={index}>
                            <td>{stock.person_name}</td>
                            <td>{stock.job_title}</td>
                            <td>{stock.trade_date}</td>
                            <td>{stock.share_qty}</td>
                            <td>{stock.market_cap_percentage}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default InsiderTrade;
