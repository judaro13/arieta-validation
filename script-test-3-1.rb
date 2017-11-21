require 'ruby-kafka'
require 'json'
require 'csv'

kafka_broker="localhost:9092"
kafka_topic="test11"
kafka = Kafka.new(
  seed_brokers: kafka_broker
)
raw = File.read("data_translink.csv").gsub(";", ",")

raw2 = CSV.new(raw, :headers => true, :header_converters => :symbol, :converters => :all)
data = raw2.to_a.map {|row| row.to_hash }

producer = kafka.producer

start = rand(0..220)
endd = start+29
size = 334
((start..endd).to_a).each_slice(3) do |a|
  data[(a[0]*size)..((a[0]+1)*size)].each do |h|
    producer.produce(JSON.dump(h), topic: "test1")
  end
  producer.deliver_messages

  data[(a[1]*size)..((a[1]+1)*size)].each do |h|
    producer.produce(JSON.dump(h), topic: "test2")
  end
  producer.deliver_messages

  data[(a[2]*size)..((a[2]+1)*size)].each do |h|
    producer.produce(JSON.dump(h), topic: "test3")
  end
  producer.deliver_messages
  sleep 6
end
