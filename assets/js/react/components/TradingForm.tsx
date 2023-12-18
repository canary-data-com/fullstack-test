import React, { useState } from 'react';

interface TradingFormProps {
  onSubmit: (formData: FormData) => void;
  companies: string[]; // List of company tickers
}

interface FormData {
  selectedCompany: string;
  transactionPerson: string;
  sharesAmount: number;
	jobTitle: string;
}

const TradingForm: React.FC<TradingFormProps> = ({ onSubmit, companies }) => {
  const [formData, setFormData] = useState<FormData>({
    selectedCompany: '',
    transactionPerson: '',
    sharesAmount: 0,
		jobTitle: '',
  });

  const handleChange = (event: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = event.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    // Automatically set the current date before submission
    const currentDate = new Date().toISOString().slice(0, 10);
    const formDataWithDate = { ...formData, transactionDate: currentDate };
    onSubmit(formDataWithDate);
  };

  return (
    <form onSubmit={handleSubmit} className="w-full max-w-md mx-auto p-4">
      <div className="mb-4">
        <label htmlFor="selectedCompany" className="block text-gray-700 font-semibold mb-2">
          Select Company:
        </label>
        <select
          id="selectedCompany"
          name="selectedCompany"
          value={formData.selectedCompany}
          onChange={handleChange}
          className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
          required
        >
          <option value="">Select a Company</option>
          {companies.map((ticker) => (
            <option key={ticker} value={ticker}>
              {ticker}
            </option>
          ))}
        </select>
      </div>
      <div className="mb-4">
        <label htmlFor="transactionPerson" className="block text-gray-700 font-semibold mb-2">
          Transaction Person:
        </label>
        <input
          type="text"
          id="transactionPerson"
          name="transactionPerson"
          value={formData.transactionPerson}
          onChange={handleChange}
					placeholder='Enter the name of the person you wish to be responsible for the transaction'
          className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
          required
        />
      </div>
      <div className="mb-4">
        <label htmlFor="sharesAmount" className="block text-gray-700 font-semibold mb-2">
          Shares Amount:
        </label>
        <input
          type="number"
          id="sharesAmount"
          name="sharesAmount"
          value={formData.sharesAmount}
          onChange={handleChange}
          className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
          required
        />
      </div>
			<div className="mb-4">
        <label htmlFor="jobTitle" className="block text-gray-700 font-semibold mb-2">
          Job Title:
        </label>
        <input
          type="text"
          id="jobTitle"
          name="jobTitle"
          value={formData.jobTitle}
          onChange={handleChange}
          className="w-full p-2 rounded border border-gray-400 focus:outline-none focus:border-fuchsia-500"
          required
        />
      </div>
			<div className="text-right mt-4">
				<button
					type="submit"
					className="bg-fuchsia-500 hover:bg-fs text-black font-semibold py-2 px-4 rounded"
				>
					Submit
				</button>
			</div>
    </form>
  );
};

export default TradingForm;