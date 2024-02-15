defmodule Trading.InsiderTradingsTest do
  use Trading.DataCase
  import Mox

  alias Trading.InsiderTradings

  describe "list_inisder_tradings/1" do
    test "list insider trading for random company" do
      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "{\"fields\":[\"cik\",\"name\",\"ticker\",\"exchange\"],\"data\":[[789019,\"MICROSOFT CORP\",\"MSFT\",\"Nasdaq\"],[320193,\"Apple Inc.\",\"AAPL\",\"Nasdaq\"],[1652044,\"Alphabet Inc.\",\"GOOGL\",\"Nasdaq\"]]}"
         }}
      end)

      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n  <feed xmlns=\"http://www.w3.org/2005/Atom\">\n    <author>\n      <email>webmaster@sec.gov</email>\n      <name>Webmaster</name>\n    </author>\n    <company-info>\n      <addresses>\n        <address type=\"mailing\">\n          <city>REDMOND</city>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n        <address type=\"business\">\n          <city>REDMOND</city>\n          <phone>425-882-8080</phone>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n      </addresses>\n      <assigned-sic>7372</assigned-sic>\n      <assigned-sic-desc>SERVICES-PREPACKAGED SOFTWARE</assigned-sic-desc>\n      <assigned-sic-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;SIC=7372&amp;owner=include&amp;count=100</assigned-sic-href>\n      <cik>0000789019</cik>\n      <cik-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=0000789019&amp;owner=include&amp;count=100</cik-href>\n      <conformed-name>MICROSOFT CORP</conformed-name>\n      <fiscal-year-end>0630</fiscal-year-end>\n      <office>Office of Technology</office>\n      <state-location>WA</state-location>\n      <state-location-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;State=WA&amp;owner=include&amp;count=100</state-location-href>\n      <state-of-incorporation>WA</state-of-incorporation>\n    </company-info>\n    <entry>\n      <category label=\"form type\" scheme=\"https://www.sec.gov/\" term=\"4\" />\n      <content type=\"text/xml\">\n        <accession-number>0001104659-24-021466</accession-number>\n        <act>34</act>\n        <amend>[Amend]</amend>\n        <file-number>005-38758</file-number>\n        <file-number-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;filenum=005-38758&amp;owner=include&amp;count=100</file-number-href>\n        <filing-date>2024-02-13</filing-date>\n        <filing-href>https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm</filing-href>\n        <filing-type>SC 13G/A</filing-type>\n        <film-number>24629094</film-number>\n        <form-name>Statement of acquisition of beneficial ownership by individuals</form-name>\n        <size>12 KB</size>\n      </content>\n      <id>urn:tag:sec.gov,2008:accession-number=0001104659-24-021466</id>\n      <link href=\"https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm\" rel=\"alternate\" type=\"text/html\" />\n      <summary type=\"html\"> &lt;b&gt;Filed:&lt;/b&gt; 2024-02-13 &lt;b&gt;AccNo:&lt;/b&gt; 0001104659-24-021466 &lt;b&gt;Size:&lt;/b&gt; 12 KB</summary>\n      <title>SC 13G/A [Amend]  - Statement of acquisition of beneficial ownership by individuals</title>\n      <updated>2024-02-13T17:09:47-05:00</updated>\n    </entry>\n   </feed>\n"
         }}
      end)

      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n  <feed xmlns=\"http://www.w3.org/2005/Atom\">\n    <author>\n      <email>webmaster@sec.gov</email>\n      <name>Webmaster</name>\n    </author>\n    <company-info>\n      <addresses>\n        <address type=\"mailing\">\n          <city>REDMOND</city>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n        <address type=\"business\">\n          <city>REDMOND</city>\n          <phone>425-882-8080</phone>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n      </addresses>\n      <assigned-sic>7372</assigned-sic>\n      <assigned-sic-desc>SERVICES-PREPACKAGED SOFTWARE</assigned-sic-desc>\n      <assigned-sic-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;SIC=7372&amp;owner=include&amp;count=100</assigned-sic-href>\n      <cik>0000789019</cik>\n      <cik-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=0000789019&amp;owner=include&amp;count=100</cik-href>\n      <conformed-name>MICROSOFT CORP</conformed-name>\n      <fiscal-year-end>0630</fiscal-year-end>\n      <office>Office of Technology</office>\n      <state-location>WA</state-location>\n      <state-location-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;State=WA&amp;owner=include&amp;count=100</state-location-href>\n      <state-of-incorporation>WA</state-of-incorporation>\n    </company-info>\n    <entry>\n      <category label=\"form type\" scheme=\"https://www.sec.gov/\" term=\"4\" />\n      <content type=\"text/xml\">\n        <accession-number>0001104659-24-021466</accession-number>\n        <act>34</act>\n        <amend>[Amend]</amend>\n        <file-number>005-38758</file-number>\n        <file-number-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;filenum=005-38758&amp;owner=include&amp;count=100</file-number-href>\n        <filing-date>2024-02-13</filing-date>\n        <filing-href>https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm</filing-href>\n        <filing-type>SC 13G/A</filing-type>\n        <film-number>24629094</film-number>\n        <form-name>Statement of acquisition of beneficial ownership by individuals</form-name>\n        <size>12 KB</size>\n      </content>\n      <id>urn:tag:sec.gov,2008:accession-number=0001104659-24-021466</id>\n      <link href=\"https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm\" rel=\"alternate\" type=\"text/html\" />\n      <summary type=\"html\"> &lt;b&gt;Filed:&lt;/b&gt; 2024-02-13 &lt;b&gt;AccNo:&lt;/b&gt; 0001104659-24-021466 &lt;b&gt;Size:&lt;/b&gt; 12 KB</summary>\n      <title>SC 13G/A [Amend]  - Statement of acquisition of beneficial ownership by individuals</title>\n      <updated>2024-02-13T17:09:47-05:00</updated>\n    </entry>\n   </feed>\n"
         }}
      end)

      assert [
               %{
                 accession_number: "0001104659-24-021466",
                 amend: "[Amend]",
                 filing_date: "2024-02-13",
                 filing_href:
                   "https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm",
                 form_name: "Statement of acquisition of beneficial ownership by individuals",
                 form_type: "4",
                 job_title: "",
                 market_cap: "",
                 person: "",
                 shares: ""
               }
             ] = InsiderTradings.list_insider_tradings(nil)
    end

    test "list insider trading for given company" do
      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "{\"fields\":[\"cik\",\"name\",\"ticker\",\"exchange\"],\"data\":[[789019,\"MICROSOFT CORP\",\"MSFT\",\"Nasdaq\"],[320193,\"Apple Inc.\",\"AAPL\",\"Nasdaq\"],[1652044,\"Alphabet Inc.\",\"GOOGL\",\"Nasdaq\"]]}"
         }}
      end)

      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n  <feed xmlns=\"http://www.w3.org/2005/Atom\">\n    <author>\n      <email>webmaster@sec.gov</email>\n      <name>Webmaster</name>\n    </author>\n    <company-info>\n      <addresses>\n        <address type=\"mailing\">\n          <city>REDMOND</city>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n        <address type=\"business\">\n          <city>REDMOND</city>\n          <phone>425-882-8080</phone>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n      </addresses>\n      <assigned-sic>7372</assigned-sic>\n      <assigned-sic-desc>SERVICES-PREPACKAGED SOFTWARE</assigned-sic-desc>\n      <assigned-sic-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;SIC=7372&amp;owner=include&amp;count=100</assigned-sic-href>\n      <cik>0000789019</cik>\n      <cik-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=0000789019&amp;owner=include&amp;count=100</cik-href>\n      <conformed-name>MICROSOFT CORP</conformed-name>\n      <fiscal-year-end>0630</fiscal-year-end>\n      <office>Office of Technology</office>\n      <state-location>WA</state-location>\n      <state-location-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;State=WA&amp;owner=include&amp;count=100</state-location-href>\n      <state-of-incorporation>WA</state-of-incorporation>\n    </company-info>\n    <entry>\n      <category label=\"form type\" scheme=\"https://www.sec.gov/\" term=\"4\" />\n      <content type=\"text/xml\">\n        <accession-number>0001104659-24-021466</accession-number>\n        <act>34</act>\n        <amend>[Amend]</amend>\n        <file-number>005-38758</file-number>\n        <file-number-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;filenum=005-38758&amp;owner=include&amp;count=100</file-number-href>\n        <filing-date>2024-02-13</filing-date>\n        <filing-href>https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm</filing-href>\n        <filing-type>SC 13G/A</filing-type>\n        <film-number>24629094</film-number>\n        <form-name>Statement of acquisition of beneficial ownership by individuals</form-name>\n        <size>12 KB</size>\n      </content>\n      <id>urn:tag:sec.gov,2008:accession-number=0001104659-24-021466</id>\n      <link href=\"https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm\" rel=\"alternate\" type=\"text/html\" />\n      <summary type=\"html\"> &lt;b&gt;Filed:&lt;/b&gt; 2024-02-13 &lt;b&gt;AccNo:&lt;/b&gt; 0001104659-24-021466 &lt;b&gt;Size:&lt;/b&gt; 12 KB</summary>\n      <title>SC 13G/A [Amend]  - Statement of acquisition of beneficial ownership by individuals</title>\n      <updated>2024-02-13T17:09:47-05:00</updated>\n    </entry>\n   </feed>\n"
         }}
      end)

      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n  <feed xmlns=\"http://www.w3.org/2005/Atom\">\n    <author>\n      <email>webmaster@sec.gov</email>\n      <name>Webmaster</name>\n    </author>\n    <company-info>\n      <addresses>\n        <address type=\"mailing\">\n          <city>REDMOND</city>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n        <address type=\"business\">\n          <city>REDMOND</city>\n          <phone>425-882-8080</phone>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n      </addresses>\n      <assigned-sic>7372</assigned-sic>\n      <assigned-sic-desc>SERVICES-PREPACKAGED SOFTWARE</assigned-sic-desc>\n      <assigned-sic-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;SIC=7372&amp;owner=include&amp;count=100</assigned-sic-href>\n      <cik>0000789019</cik>\n      <cik-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=0000789019&amp;owner=include&amp;count=100</cik-href>\n      <conformed-name>MICROSOFT CORP</conformed-name>\n      <fiscal-year-end>0630</fiscal-year-end>\n      <office>Office of Technology</office>\n      <state-location>WA</state-location>\n      <state-location-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;State=WA&amp;owner=include&amp;count=100</state-location-href>\n      <state-of-incorporation>WA</state-of-incorporation>\n    </company-info>\n    <entry>\n      <category label=\"form type\" scheme=\"https://www.sec.gov/\" term=\"4\" />\n      <content type=\"text/xml\">\n        <accession-number>0001104659-24-021466</accession-number>\n        <act>34</act>\n        <amend>[Amend]</amend>\n        <file-number>005-38758</file-number>\n        <file-number-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;filenum=005-38758&amp;owner=include&amp;count=100</file-number-href>\n        <filing-date>2024-02-13</filing-date>\n        <filing-href>https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm</filing-href>\n        <filing-type>SC 13G/A</filing-type>\n        <film-number>24629094</film-number>\n        <form-name>Statement of acquisition of beneficial ownership by individuals</form-name>\n        <size>12 KB</size>\n      </content>\n      <id>urn:tag:sec.gov,2008:accession-number=0001104659-24-021466</id>\n      <link href=\"https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm\" rel=\"alternate\" type=\"text/html\" />\n      <summary type=\"html\"> &lt;b&gt;Filed:&lt;/b&gt; 2024-02-13 &lt;b&gt;AccNo:&lt;/b&gt; 0001104659-24-021466 &lt;b&gt;Size:&lt;/b&gt; 12 KB</summary>\n      <title>SC 13G/A [Amend]  - Statement of acquisition of beneficial ownership by individuals</title>\n      <updated>2024-02-13T17:09:47-05:00</updated>\n    </entry>\n   </feed>\n"
         }}
      end)

      assert [
               %{
                 accession_number: "0001104659-24-021466",
                 amend: "[Amend]",
                 company: "MICROSOFT CORP",
                 filing_date: "2024-02-13",
                 filing_href:
                   "https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm",
                 form_name: "Statement of acquisition of beneficial ownership by individuals",
                 form_type: "4",
                 job_title: "",
                 market_cap: "",
                 person: "",
                 shares: ""
               }
             ] = InsiderTradings.list_insider_tradings("MICROSOFT CORP")
    end

    test "when 403 status code returned" do
      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:error,
         %HTTPoison.Response{
           status_code: 403,
           body:
             "{\"fields\":[\"cik\",\"name\",\"ticker\",\"exchange\"],\"data\":[[789019,\"MICROSOFT CORP\",\"MSFT\",\"Nasdaq\"],[320193,\"Apple Inc.\",\"AAPL\",\"Nasdaq\"],[1652044,\"Alphabet Inc.\",\"GOOGL\",\"Nasdaq\"]]}"
         }}
      end)

      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n  <feed xmlns=\"http://www.w3.org/2005/Atom\">\n    <author>\n      <email>webmaster@sec.gov</email>\n      <name>Webmaster</name>\n    </author>\n    <company-info>\n      <addresses>\n        <address type=\"mailing\">\n          <city>REDMOND</city>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n        <address type=\"business\">\n          <city>REDMOND</city>\n          <phone>425-882-8080</phone>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n      </addresses>\n      <assigned-sic>7372</assigned-sic>\n      <assigned-sic-desc>SERVICES-PREPACKAGED SOFTWARE</assigned-sic-desc>\n      <assigned-sic-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;SIC=7372&amp;owner=include&amp;count=100</assigned-sic-href>\n      <cik>0000789019</cik>\n      <cik-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=0000789019&amp;owner=include&amp;count=100</cik-href>\n      <conformed-name>MICROSOFT CORP</conformed-name>\n      <fiscal-year-end>0630</fiscal-year-end>\n      <office>Office of Technology</office>\n      <state-location>WA</state-location>\n      <state-location-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;State=WA&amp;owner=include&amp;count=100</state-location-href>\n      <state-of-incorporation>WA</state-of-incorporation>\n    </company-info>\n    <entry>\n      <category label=\"form type\" scheme=\"https://www.sec.gov/\" term=\"4\" />\n      <content type=\"text/xml\">\n        <accession-number>0001104659-24-021466</accession-number>\n        <act>34</act>\n        <amend>[Amend]</amend>\n        <file-number>005-38758</file-number>\n        <file-number-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;filenum=005-38758&amp;owner=include&amp;count=100</file-number-href>\n        <filing-date>2024-02-13</filing-date>\n        <filing-href>https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm</filing-href>\n        <filing-type>SC 13G/A</filing-type>\n        <film-number>24629094</film-number>\n        <form-name>Statement of acquisition of beneficial ownership by individuals</form-name>\n        <size>12 KB</size>\n      </content>\n      <id>urn:tag:sec.gov,2008:accession-number=0001104659-24-021466</id>\n      <link href=\"https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm\" rel=\"alternate\" type=\"text/html\" />\n      <summary type=\"html\"> &lt;b&gt;Filed:&lt;/b&gt; 2024-02-13 &lt;b&gt;AccNo:&lt;/b&gt; 0001104659-24-021466 &lt;b&gt;Size:&lt;/b&gt; 12 KB</summary>\n      <title>SC 13G/A [Amend]  - Statement of acquisition of beneficial ownership by individuals</title>\n      <updated>2024-02-13T17:09:47-05:00</updated>\n    </entry>\n   </feed>\n"
         }}
      end)

      Trading.InsiderTradingClientMock
      |> expect(:http_get, fn _url, _header ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body:
             "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>\n  <feed xmlns=\"http://www.w3.org/2005/Atom\">\n    <author>\n      <email>webmaster@sec.gov</email>\n      <name>Webmaster</name>\n    </author>\n    <company-info>\n      <addresses>\n        <address type=\"mailing\">\n          <city>REDMOND</city>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n        <address type=\"business\">\n          <city>REDMOND</city>\n          <phone>425-882-8080</phone>\n          <state>WA</state>\n          <street1>ONE MICROSOFT WAY</street1>\n          <zip>98052-6399</zip>\n        </address>\n      </addresses>\n      <assigned-sic>7372</assigned-sic>\n      <assigned-sic-desc>SERVICES-PREPACKAGED SOFTWARE</assigned-sic-desc>\n      <assigned-sic-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;SIC=7372&amp;owner=include&amp;count=100</assigned-sic-href>\n      <cik>0000789019</cik>\n      <cik-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;CIK=0000789019&amp;owner=include&amp;count=100</cik-href>\n      <conformed-name>MICROSOFT CORP</conformed-name>\n      <fiscal-year-end>0630</fiscal-year-end>\n      <office>Office of Technology</office>\n      <state-location>WA</state-location>\n      <state-location-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;State=WA&amp;owner=include&amp;count=100</state-location-href>\n      <state-of-incorporation>WA</state-of-incorporation>\n    </company-info>\n    <entry>\n      <category label=\"form type\" scheme=\"https://www.sec.gov/\" term=\"4\" />\n      <content type=\"text/xml\">\n        <accession-number>0001104659-24-021466</accession-number>\n        <act>34</act>\n        <amend>[Amend]</amend>\n        <file-number>005-38758</file-number>\n        <file-number-href>https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&amp;filenum=005-38758&amp;owner=include&amp;count=100</file-number-href>\n        <filing-date>2024-02-13</filing-date>\n        <filing-href>https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm</filing-href>\n        <filing-type>SC 13G/A</filing-type>\n        <film-number>24629094</film-number>\n        <form-name>Statement of acquisition of beneficial ownership by individuals</form-name>\n        <size>12 KB</size>\n      </content>\n      <id>urn:tag:sec.gov,2008:accession-number=0001104659-24-021466</id>\n      <link href=\"https://www.sec.gov/Archives/edgar/data/789019/000110465924021466/0001104659-24-021466-index.htm\" rel=\"alternate\" type=\"text/html\" />\n      <summary type=\"html\"> &lt;b&gt;Filed:&lt;/b&gt; 2024-02-13 &lt;b&gt;AccNo:&lt;/b&gt; 0001104659-24-021466 &lt;b&gt;Size:&lt;/b&gt; 12 KB</summary>\n      <title>SC 13G/A [Amend]  - Statement of acquisition of beneficial ownership by individuals</title>\n      <updated>2024-02-13T17:09:47-05:00</updated>\n    </entry>\n   </feed>\n"
         }}
      end)

      assert {:error, _reason} = InsiderTradings.list_insider_tradings("MICROSOFT CORP")
    end
  end
end
