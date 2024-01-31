import "intl";
import "intl/locale-data/jsonp/en-US"

export default function TradingRow({ trading }) {
  
  function formatMoney(amount) {
    if (amount) {
      return Intl.NumberFormat("en-US", {
        style: "currency", currency: "USD"
      }).format(amount);
    }
    return "N/A";
  }

  function formatPercent(value) {
    if (value) {
      return `${value}%`;
    }
    return "N/A";
  }


  return (
    <tr>
      <td>{trading.ticker}</td>
      <td>{trading.name}</td>
      <td>{trading.startDate}</td>
      <td>{trading.shares}</td>
      <td>{formatMoney(trading.amount)}</td>
      <td>{formatPercent(trading.market_cap_percentage)}</td>
      <td>{formatMoney(trading.market_cap)}</td>
    </tr>
  );
}
