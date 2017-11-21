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

start = rand(0..73)
endd = start+29
batch_size = 1000

((start..endd).to_a).each  do |a|
  data[(a*batch_size)..((a+1)*batch_size)].each do |h|
    producer.produce(JSON.dump(h), topic: "test")
  end
  producer.deliver_messages
  sleep 6
end
