//
//  ProfileView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject var viewModel: ProfileViewModel = .init()
    
    @State internal var userName: String = "Dilan Anuruddha"
    @State internal var memberSince: String = "April 2025"
    @State internal var userBio: String = ""
    
    @State internal var isEditingBio: Bool = false
    @State internal var editedBio: String = ""
    @State internal var selectedItem: PhotosPickerItem?
    @State internal var profileImage: Image?
    @State internal var uiProfileImage: UIImage?
    
    @State private var publishedStories = 17
    @State private var totalListeners = 2356
    @State private var totalLikes = 843
    @State private var avgListenTime = "6.4 min"
    @State private var mostPopularCategory = "Adventures"
    
    let stories = [
        StoryItem(
            title: "Summer in Tokyo",
            categories: ["Travel", "Culture"],
            listenCount: 486,
            likeCount: 194,
            duration: "8:22"
        ),
        StoryItem(
            title: "Grandma's Secret Recipe",
            categories: ["Family", "Food", "Tradition"],
            listenCount: 327,
            likeCount: 152,
            duration: "12:05"
        ),
        StoryItem(
            title: "First Day at School",
            categories: ["Childhood", "Memories"],
            listenCount: 251,
            likeCount: 98,
            duration: "5:38"
        )
    ]
    
    var body: some View {
        NavigationStack(path: $appSettings.profilePaths) {
            ScrollView {
                VStack(spacing: 24) {
                    header()
                    
                    statsGridSection
                    
                    storiesSection
                    
                    activitySection
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                
            }
        }
    }
    
    private var statsGridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Story Stats")
                .font(.system(size: 18, weight: .bold))
                .padding(.leading, 8)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    StatCard(
                        icon: "book.fill",
                        value: "\(publishedStories)",
                        label: "Stories",
                        color: .blue
                    )
                    
                    StatCard(
                        icon: "ear.fill",
                        value: "\(totalListeners)",
                        label: "Listeners",
                        color: .green
                    )
                }
                
                HStack(spacing: 16) {
                    StatCard(
                        icon: "heart.fill",
                        value: "\(totalLikes)",
                        label: "Total Likes",
                        color: .red
                    )
                    
                    StatCard(
                        icon: "clock.fill",
                        value: avgListenTime,
                        label: "Avg Listen Time",
                        color: .orange
                    )
                }
                
                HStack(spacing: 16) {
                    StatCard(
                        icon: "chart.bar.fill",
                        value: "62%",
                        label: "Completion Rate",
                        color: .purple
                    )
                    
                    StatCard(
                        icon: "tag.fill",
                        value: mostPopularCategory,
                        label: "Top Category",
                        color: .indigo
                    )
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Published Stories")
                    .font(.system(size: 18, weight: .bold))
                
                Spacer()
                
                Button(action: {}) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 8)
            
            VStack(spacing: 12) {
                ForEach(stories, id: \.title) { story in
                    StoryRow(story: story)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Activity Chart
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Activity")
                .font(.system(size: 18, weight: .bold))
                .padding(.leading, 8)
            
            // Mock activity chart
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7) { i in
                    let height = [0.3, 0.5, 0.7, 0.9, 0.6, 0.8, 0.4][i % 7]
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(height: CGFloat(180 * height))
                        
                        Text(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"][i % 7])
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            
            HStack {
                Spacer()
                Text("Based on story publishing activity")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct StoryRow: View {
    let story: StoryItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Story Thumbnail
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: "waveform")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(story.title)
                    .font(.system(size: 16, weight: .semibold))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(story.categories, id: \.self) { category in
                            Text(category)
                                .font(.system(size: 10))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                }
                
                HStack(spacing: 12) {
                    Label("\(story.listenCount)", systemImage: "ear")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Label("\(story.likeCount)", systemImage: "heart")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Label(story.duration, systemImage: "clock")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

struct StoryItem {
    let title: String
    let categories: [String]
    let listenCount: Int
    let likeCount: Int
    let duration: String
}

// MARK: - Preview
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AppSettings())
    }
}
