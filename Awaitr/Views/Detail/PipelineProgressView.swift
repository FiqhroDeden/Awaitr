//
//  PipelineProgressView.swift
//  Awaitr
//

import SwiftUI

struct PipelineProgressView: View {
    let status: WaitStatus
    let template: PipelineTemplate

    private var steps: [(label: String, index: Int)] {
        var result = template.stages.enumerated().map { index, stage in
            (label: template.shortLabel(for: stage), index: index)
        }
        result.append((label: "Decision", index: template.stages.count))
        return result
    }

    private var completedCount: Int {
        if status.isTerminal {
            return steps.count
        }
        guard let index = template.pipelineIndex(of: status) else {
            return 0
        }
        return index + 1
    }

    private var categoryColor: Color {
        Color(category: template.category)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { offset, step in
                if offset > 0 {
                    connector(completed: offset < completedCount)
                        .padding(.bottom, 18)
                }
                stepView(number: offset + 1, label: step.label, completed: offset < completedCount, isLast: offset == steps.count - 1)
            }
        }
    }

    // MARK: - Step Circle

    private func stepView(number: Int, label: String, completed: Bool, isLast: Bool) -> some View {
        VStack(spacing: 4) {
            circleContent(number: number, completed: completed, isLast: isLast)
                .frame(width: 28, height: 28)

            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(completed ? categoryColor : Color(hex: "999999"))
        }
    }

    @ViewBuilder
    private func circleContent(number: Int, completed: Bool, isLast: Bool) -> some View {
        if isLast && status.isPositive {
            Circle()
                .fill(Color(hex: "3B6D11").opacity(0.15))
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(hex: "3B6D11"))
                )
        } else if isLast && status.isNegative {
            Circle()
                .fill(Color(hex: "E24B4A").opacity(0.15))
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(hex: "E24B4A"))
                )
        } else {
            Circle()
                .fill(completed ? categoryColor.opacity(0.15) : Color.black.opacity(0.05))
                .overlay(
                    Text("\(number)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(completed ? categoryColor : Color(hex: "999999"))
                )
        }
    }

    // MARK: - Connector

    private func connector(completed: Bool) -> some View {
        Rectangle()
            .fill(completed ? categoryColor.opacity(0.3) : Color.black.opacity(0.06))
            .frame(height: 3)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 24) {
        ForEach(PipelineTemplate.allCases) { tmpl in
            VStack(spacing: 4) {
                Text(tmpl.label)
                    .font(.caption)
                PipelineProgressView(status: tmpl.stages.first!, template: tmpl)
            }
        }
    }
    .padding()
}
