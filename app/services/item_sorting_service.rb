class ItemSortingService
  ASCENDING_ORDER = 'asc'.freeze
  DESCENDING_ORDER = 'desc'.freeze
  MOST_LIKED = 'most_liked'.freeze
  MOST_COMMENTED = 'most_commented'.freeze
  NO_LIKES = 'no_likes'.freeze
  NO_COMMENTS = 'no_comments'.freeze

  def self.apply_sort_items(items, items_sorting)
    case items_sorting
    when ASCENDING_ORDER
      order_items_by_creation_date(items, :asc)
    when DESCENDING_ORDER
      order_items_by_creation_date(items, :desc)
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

  private

  def self.order_items_by_creation_date(items, order)
    items.order(created_at: order)
  end

  def self.order_items_by_most_liked(items)
    items
      .joins(:likes)
      .group('items.id')
      .order('COUNT(likes.id) DESC')
  end

  def self.order_items_by_most_commented(items)
    items
      .joins(:comments)
      .group('items.id')
      .order('COUNT(comments.id) DESC')
  end

  def self.items_with_no_likes(items)
    items
      .left_outer_joins(:likes)
      .where(likes: { id: nil })
      .order(created_at: :desc)
  end

  def self.items_with_no_comments(items)
    items
      .left_outer_joins(:comments)
      .where(comments: { id: nil })
      .order(created_at: :desc)
  end

  def self.default_sort_order(items)
    order_items_by_creation_date(items, :desc)
  end
end
