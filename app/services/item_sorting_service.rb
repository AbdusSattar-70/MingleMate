class ItemSortingService
  ASCENDING_ORDER = 'ASC'.freeze
  DESCENDING_ORDER = 'DESC'.freeze
  MOST_LIKED = 'most_liked'.freeze
  MOST_COMMENTED = 'most_commented'.freeze
  NO_LIKES = 'no_likes'.freeze
  NO_COMMENTS = 'no_comments'.freeze

  def self.apply_sort_items(items, items_sorting)
    case items_sorting
    when ASCENDING_ORDER
      order_items_by_creation_date(items, ASCENDING_ORDER)
    when DESCENDING_ORDER
      order_items_by_creation_date(items, DESCENDING_ORDER)
    when MOST_LIKED
      order_items_by_most_liked(items)
    when MOST_COMMENTED
      order_items_by_most_commented(items)
    when NO_LIKES
      items_with_no_likes(items)
    when NO_COMMENTS
      items_with_no_comments(items)
    else
      default_sort_order(items)
    end
  end

  def self.order_items_by_creation_date(items, order)
    items.order(created_at: order)
  end

  def self.order_items_by_most_liked(items)
  items
    .left_joins(:likes)
    .group('items.id')
    .order('COUNT(DISTINCT likes.id) DESC')
end

def self.order_items_by_most_commented(items)
  items
    .left_joins(:comments)
    .group('items.id')
    .order('COUNT(DISTINCT comments.id) DESC')
end

  def self.items_with_no_likes(items)
    items
      .left_outer_joins(:likes)
      .where(likes: { id: nil })
      .order(created_at: DESCENDING_ORDER)
  end

  def self.items_with_no_comments(items)
    items
      .left_outer_joins(:comments)
      .where(comments: { id: nil })
      .order(created_at: DESCENDING_ORDER)
  end

  def self.default_sort_order(items)
    order_items_by_creation_date(items, DESCENDING_ORDER)
  end
end
