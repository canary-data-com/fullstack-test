import TradingRow from "../TradingRow";

export default function TradingTable({ tradings, ...rest }) {
  const rows = [];

  tradings.forEach((trading) => {
    rows.push(
      <TradingRow
        trading={trading}
        key={trading.id} />
    );
  });

  return (
    <>
      {tradings.length === 0 && (
        <span className="">
          No data yet...
        </span>
      )}

      {tradings.length > 1 && (
        <table className="table" {...rest}>
          <thead>
            <tr>
              <th>Ticker</th>
              <th>Name</th>
              <th>Date</th>
              <th>Shares</th>
              <th>Amount</th>
              <th>Market Cap %</th>
              <th>Market Cap</th>
            </tr>
          </thead>
          <tbody>{rows}</tbody>
        </table>
      )}
    </>


  );
}