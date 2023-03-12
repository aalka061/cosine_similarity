# require 'nlp'
require 'set'
articles = [
    { id:1, content: "such as the penny sleeves or hard sleeves (toploaders)," },
    { id:2, content: "such as the penny sleeves or hard sleeves (toploaders), so you can choose the one that best fits " },
    { id:3, content: "A third article, discussing the benefits of pears and grapes" },
]

products = [
    {id: 1, title: "100 Pack Ultra Pro Card Sleeves for Pokemon "},
    {id: 2, title: "25 Pack Ultra Pro Card Toploaders (3'' x 4'')"},
    {id: 3, title: "Banana holder"},
    {id: 4, title: "Kiwi peeler"},
    {id: 5, title: "Pear corer"},
    {id: 6, title: "Grape press"},
]

def preprocess_text(text)
    # tokenize, remove stop words, etc. 
    # you could use a library like "nlp"
    # for similicity, let us just split the text into words 
    text.downcase.split(/\W+/)
end 

def build_article_rep(article)
    words = preprocess_text(article[:content])
    Hash[words.group_by(&:itself).map{|k, v| [k, v.length]}]
end

def build_product_rep(product)
    words = preprocess_text(product[:title])
    Hash[words.group_by(&:itself).map{|k, v| [k, v.length] }]
end 

def compute_similarity(article_rep, product_rep)
    # compute the cosine similarity between the two bag-of-words representations 
    article_words = article_rep.keys.to_set
    product_words = product_rep.keys.to_set 
    shared_words = article_words & product_words

    numerator = shared_words.sum{|word| article_rep[word] * product_rep[word] }
    denominator = Math.sqrt(article_rep.values.sum{|count| count ** 2}) * Math.sqrt(product_rep.values.sum{|count| count ** 2})
    denominator > 0 ? numerator / denominator : 0
end


articles.each do |article|
    article_rep = build_article_rep(article)
    matching_products = products.select{|product| compute_similarity(article_rep, build_product_rep(product)) > 0.1}

    puts "Article #{article[:id]} matches products #{matching_products.map{|p| p[:title] }.join(', ') }" 
end 