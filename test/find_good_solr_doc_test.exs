HTTPotion.start

defmodule FindGoodSolrDocTest do
  use ExUnit.Case
  use Jazz

  @solr_fields [
    "id",
    "application_name",
    "applicant_filing_date_int",
    "uspc_full_classification",
    "cpc_inventive",
    "cpc_additional",
    "priority_claims_date",
    "related_appl_filing_date",
    "assistant_examiner",
    "primary_examiner",
    "ipc_code",
    "application_number"
  ]
  @solr_query_url "http://localhost:8983/solr/us_patent_grant/select?q=*:*&rows=1000&fl=#{Enum.join(@solr_fields, "%2C")}&wt=json"
  @json HTTPotion.get(@solr_query_url).body
  @reply JSON.decode!(@json)
  @response @reply["response"]
  @docs @response["docs"]

  test "sorts by the number of fields present in the doc" do
    IO.puts "Best results are:"
    @docs
    |> Enum.map(&({&1["id"], (Map.keys(&1) |> Enum.count)}))
    |> Enum.sort(fn({_, a}, {_, b}) -> a > b end)
    |> Enum.take(10)
    |> Enum.each(&IO.inspect/1)
  end
end
