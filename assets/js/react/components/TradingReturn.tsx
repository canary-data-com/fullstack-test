import React from 'react';

interface ResultComponentProps {
	result: {
		ticker: string;
		person: string;
		job_title: string;
		date: string;
		shares: number;
		market_cap_percentage: number;
	};
}

const ResultComponent: React.FC<ResultComponentProps> = ({ result }) => {
	console.log(result)
	return (
		<div className="mt-4">
			<h2 className="text-xl font-semibold">Result:</h2>
			<p>Ticker/Company: {result.ticker}</p>
			<p>Transaction Person: {result.person}</p>
			<p>Job Title: {result.job_title}</p>
			<p>Date: {result.date}</p>
			<p>Shares: {result.shares}</p>
			<p>Market Cap Percentage: {result.market_cap_percentage.toPrecision(2)}%</p>
		</div>
	);
};

export default ResultComponent;