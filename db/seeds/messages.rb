messages = [
  [
    'Edgar Allan Poe',
    'Those who dream by day are cognizant of many things that escape those who dream only at night.'
  ],
  [
    'Michael Dell',
    "Our business is about technology, yes. But it's also about operations and customer relationships."
  ],
  [
    'Michael Dell',
    'Twenty years and $40 billion. They seem like good round numbers.'
  ],
  [
    'Richard P. Feynmann',
    "It doesn't matter how beautiful your theory is, it doesn't matter how smart you are. If it doesn't agree with experiment, it's wrong."
  ],
  [
    'Richard P. Feynmann',
    "Poets say science takes away from the beauty of the stars - mere globs of gas atoms. I, too, can see the stars on a desert night, and feel them. But do I see less or more?"
  ],
  [
    'Richard P. Feynmann',
    "For a successful technology, reality must take precedence over public relations, for Nature cannot be fooled."
  ],
  [
    'Guy Kawasaki',
    "A good idea is about ten percent and implementation and hard work, and luck is 90 percent."
  ],
  [
    'Guy Kawasaki',
    "Create something, sell it, make it better, sell it some more and then create something that obsoletes what you used to make."
  ],
  [
    'Guy Kawasaki',
    "A 50-year-old company can innovate as well as two guys/gals in a garage."
  ],
  [
    'Guy Kawasaki',
    "A crash is when your competitor's program dies. When your program dies, it is an 'idiosyncrasy'."
  ],
  [
    'Guy Kawasaki',
    "Coming from the U.S., you tend to look at one homogeneous market with 350 million people. But in Europe, every country has its own customs and laws."
  ],
  [
    'Guy Kawasaki',
    "I think that no one, or very few, are born as good presenters. It's a skill that you learn."
  ]
]

p "create messages"
messages.each do |msg|
  m = Services::Messages.new.create(
    author_name: msg.first,
    message_type: 0,
    body:  msg.second,
    title: msg.second
  )
  raise "Message is invalid: #{m.errors}" if !m.valid?
end